class Rating
	include Mongoid::Document

	belongs_to :response
	belongs_to :user

	auto_increment :id
end