class User
	include Mongoid::Document
	field :name, type: String
	field :email, type: String
	field :teacher, type: Boolean

	has_many :terms

	auto_increment :id
end