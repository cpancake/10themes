class MyApp < Sinatra::Application
	get '/user/logout' do
		session[:user] = nil
		redirect '/'
	end
	get '/user/login' do			
		redirect '/auth/google_student'
	end
	get '/user/login/teacher' do
		redirect '/auth/google_teacher'
	end
	get '/auth/google/callback' do
		info = request.env['omniauth.auth'].info.to_hash
		email = info['email']
		name = info['name']
		u = User.where(email: email).first
		if not u
			user = User.new
			user.name = name
			user.email = email
			user.save!
			u = user
		elsif u.name != name
			u.name = name
			u.save!
		end
		session[:user] = {email: email, name: name, id: u.id, teacher: (u.teacher or false)}
		redirect '/'
	end
	get '/auth/google_teacher/callback' do
		info = request.env['omniauth.auth'].info.to_hash
		email = info['email']
		name = info['name'] or email.gsub(/@(pvrsd\.)pioneervalley.k12.ma.us/, "")
		if not User.where(email: email).exists?
			user = User.new
			user.name = name
			user.email = email
			user.teacher = true
			user.save!
		end
		user.name = name
		session[:user] = {email: email, name: name, teacher: true}
		redirect '/'
	end
	get '/auth/failure' do
		@error = 'authentication error'
		@error_message = <<MSG
<span class="dictionary_term">
	<strong>au·then·ti·ca·tion er·ror</strong> <em>noun</em>
</span>
<p class="dictionary_definition">
	Something went wrong, and we're not sure exactly what. You can try again, though!
</p>
MSG
		if params[:message] == 'invalid_credentials'
			@error = 'invalid credentials'
			@error_message = <<MSG
<span class="dictionary_term">
	<strong>in·va·lid cre·den·tials</strong> <em>noun</em>
</span>
<p class="dictionary_definition">
	Whatever you tried to do, it doesn't quite match what it should be. Trying again might fix it!
</p>
MSG
		end
		erb :error
	end
end