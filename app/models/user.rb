class User < ActiveRecord::Base
	has_many :friendships
end
