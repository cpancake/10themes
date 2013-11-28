class MyApp < Sinatra::Application
	get '/term/new' do
		halt 403 if not session[:user] or not session[:user][:teacher]
		erb :'term/new'
	end
	get '/term/edit/:id' do
		halt 403 if not session[:user] or not session[:user][:teacher]
		term = Term.where(id: (params[:id].to_i or 0)).first
		halt 404 if not term
		@term = term.term
		erb :'term/edit'
	end
	post '/term/edit/:id' do
		halt 403 if not session[:user] or not session[:user][:teacher]
		term = Term.where(id: (params[:id].to_i or 0)).first
		halt 404 if not term
		term.term = params[:term]
		term.save!
		redirect '/term/view/' + term.id.to_s
	end
	post '/term/new' do
		halt 403 if not session[:user] or not session[:user][:teacher]
		term = Term.new
		term.term = params[:term]
		term.time = Time.now
		term.user = User.where(email: session[:user][:email]).first
		term.save!
		redirect '/term/view/' + term.id.to_s
	end
	get '/term/view/:id' do
		terms = Term.where(id: params[:id].to_i)
		halt 404 if not terms.exists?
		t = terms.first
		u = t.user
		@term = {
			term: t.term, 
			user: {
				name: u.name,
				id:   u.id,
				teacher: (u.teacher or false)
			},
			date: t.time.ago_in_words,
			responses: t.responses,
			id: params[:id].to_i
		}
		@term[:responses] = (@term[:responses].sort{ |x, y| x.ratings.count <=> y.ratings.count }).reverse if @term[:responses].length > 0
		@markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new({
			no_images: true,
			safe_links_only: true,
			filter_html: true,
			hard_wrap: true
		}), 
		{
			superscript: true, 
			disable_indented_code_blocks: true, 
			autolink: true
		})
		erb :'term/view'
	end
	post '/term/response/rate' do
		halt 403 if not session[:user]
		id = (params[:resp_id] or 0).to_i
		resp = Response.where(id: id).first
		halt 404 if not resp or not id
		r = Rating.where(user: User.where(email: session[:user][:email]).first, id: id)
		if r.exists?
			r.delete
		else
			rating = Rating.new
			rating.user = User.where(email: session[:user][:email]).first
			rating.response = resp
			rating.save!
		end
		new_rating = Rating.where(response: resp).count
		redirect '/term/view/' + resp.term.id.to_s + '#response' + resp.id.to_s if not params[:ajax]
		JSON.generate({'result' => 'success', 'rating' => new_rating})
	end
	post '/term/response/add' do
		halt 403 if not session[:user]
		id = (params[:post_id] or 0).to_i
		term = Term.where(id: id).first
		halt 404 if not term or not id
		halt 400 if not params[:response]
		response = Response.new
		response.response = params[:response]
		response.time = Time.now
		response.user = User.where(email: session[:user][:email]).first
		response.term = term
		response.save!
		redirect '/term/view/' + id.to_s + '#response' + response.id.to_s
	end
	get '/term/response/edit/:id' do
		halt 403 if not session[:user]
		id = (params[:id] or 0).to_i
		resp = Response.where(id: id).first
		halt 403 if resp.user.id != session[:user][:id]
		halt 404 if not resp
		@resp = resp.response
		erb :'term/edit_response'
	end
	post '/term/response/edit/:id' do
		halt 403 if not session[:user]
		id = (params[:id] or 0).to_i
		resp = Response.where(id: id).first
		halt 403 if resp.user.id != session[:user][:id]
		halt 404 if not resp
		halt 400 if not params[:response]
		resp.response = params[:response]
		resp.save!
		redirect '/term/view/' + resp.term.id.to_s
	end
end