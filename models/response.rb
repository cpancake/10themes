class Response
	include Mongoid::Document
	field :response, type: String
	field :time, type: Time

	belongs_to :user
	belongs_to :term
	has_many :ratings

	auto_increment :id
end