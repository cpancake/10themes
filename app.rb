require 'sinatra/base'
require 'sinatra/reloader'
require 'require_all'
require 'omniauth/strategies/google_oauth2'
require 'mongoid'
require 'mongoid_auto_increment'
require 'time_ago_in_words'
require 'redcarpet'
require 'json'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class MyApp < Sinatra::Application
	enable :sessions

	set :root, File.dirname(__FILE__)
	set :show_exceptions, false

	configure :development do
		register Sinatra::Reloader
	end

	configure do
		Mongoid.load! './mongoid.yml'
	end

	use OmniAuth::Builder do
		provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], 
		{
			name: 'google_student',
			scope: 'userinfo.profile,userinfo.email',
			hd: 'pioneervalley.k12.ma.us',
			callback_path: '/auth/google/callback'
		}
		provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], 
		{
			name: 'google_teacher',
			scope: 'userinfo.profile,userinfo.email',
			hd: 'pvrsd.pioneervalley.k12.ma.us',
			callback_path: '/auth/google_teacher/callback'
		}
	end

end

require_all 'models'
require_all 'routes'

MyApp.run! if __FILE__ == $0