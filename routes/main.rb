class MyApp < Sinatra::Application
	get '/' do
		erb :main
	end
	error do
		@error = 'server error'
		@error_message = <<MSG
<span class="dictionary_term">
	<strong>serv·er er·ror</strong> <em>noun</em>
</span>
<p class="dictionary_definition">
	Something happened over here, and it means that whatever you're doing couldn't be completed. Trying again will probably help.
</p>
MSG
	erb :error
	end
	error 403 do
		@error = 'access forbidden'
		@error_message = <<MSG
<span class="dictionary_term">
	<strong>ac·cess for·bid·den</strong> <em>noun</em>
</span>
<p class="dictionary_definition">
	Whatever you're trying to do, you can't do it. Trying again probably won't help in this case, but it wouldn't hurt.
</p>
MSG
		erb :error
	end
	not_found do
		@error = 'not found'
		@error_message = <<MSG
<span class="dictionary_term">
	<strong>not found</strong> <em>adj</em>
</span>
<p class="dictionary_definition">
	The place you're trying to go to doesn't exist. Spelling error? Broken link? We don't know, but you should try something else.
</p>
MSG
		erb :error
	end
	get '/error' do
		0/0
	end
end