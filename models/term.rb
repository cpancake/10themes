class Term
	include Mongoid::Document
	field :term, type: String
	field :time, type: Time

	belongs_to :user
	has_many :responses

	auto_increment :id
end