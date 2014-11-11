class Attendee < ActiveRecord::Base
  belongs_to :user
  belongs_to :graph

	validates_uniqueness_of :user_id, scope: :graph_id
end
