class Entrance < ActiveRecord::Base

  after_save :process_entrance

  belongs_to :graph

  def add_user_and_friends(access_token)
    p "Facebook access token is #{access_token}"
    graph_api_instance = Koala::Facebook::API.new(access_token)
    friends = graph_api_instance.get_connections("me","friends")
    original_user_profile = graph_api_instance.get_object("me")
    self.user_name = original_user_profile["name"]

    # find or create the user who is inputting the data

    original_user = User.find_or_create_by(facebook_id: original_user_profile["id"])

    original_user.update_attributes({name: original_user_profile["name"], 
                                facebook_id: original_user_profile["id"], 
                                facebook_pic_small: graph_api_instance.get_picture(original_user_profile["id"]),
                                phone: self.phone})

    original_user.save

    #add users friends as friendships
    ActiveRecord::Base.transaction do
      friends.each do |f|
        user = User.find_or_create_by(facebook_id: f["id"])
        original_user.friendships.create(friend: user.id)
      end
    end

    return original_user
  end

  def create_mutual_friendships

    # this goes through and finds all the unique combinations between the users at the party
    partygoers_ids = Graph.find(self.graph_id).users.map { |u| u.id }
    combinations_of_partygoers = (0...(partygoers_ids.size-1)).inject([]) {|pairs,x| pairs += ((x+1)...partygoers_ids.size).map {|y| [partygoers_ids[x],partygoers_ids[y]]}}

    # with those combinations of partygoers, we iterate through to find their friends and mutual ones
    combinations_of_partygoers.each do |combo|
      first_partygoer = combo[0]
      first_partygoer_friends_array = User.find(first_partygoer).friendships.map {|f| f.friend}
      second_partygoer = combo[1]
      second_partygoer_friends_array = User.find(second_partygoer).friendships.map {|f| f.friend}

      #this finds mutual friends 
      mutual_friends_array = first_partygoer_friends_array & second_partygoer_friends_array

      mutual_friends_array.each do |mf|
        MutualFriendship.find_or_create_by(user_at_party: first_partygoer, user_at_party_2: second_partygoer, mutual_friend: mf)
      end
    end
  end

  def send_sms_for_user_page(user,graph_id)
    # makes a twilio client
    @twilio_client = Twilio::REST::Client.new(ENV['TWILIO_SID'],ENV['TWILIO_TOKEN'])
    # grabs the URL to send the person, using the user object and graph_id from parameters
    users_custom_url = Rails.application.routes.url_helpers.graph_user_url(graph_id,user)
    message = "See your mutual friends at #{users_custom_url}"
    # sends text to person with a cute string around it
    @twilio_client.account.sms.messages.create(
      :from => "+1#{ENV['TWILIO_PHONE_NUMBER']}", 
      :to => user.phone,
      :body => message
    )
  end

  def normalize_params
    self.phone = self.phone.gsub(/[^0-9a-z]/i, '')
  end

  protected

  def process_entrance
    puts "Process entrance running"
    normalize_params
    user = self.add_user_and_friends(self.facebook_token)
    self.graph.attendees.create(:user_id => user.id)
    puts "User added"
    self.create_mutual_friendships
    puts "Mutual friendships created"
    self.graph.create_graph
    puts "Graph created"
    # send_sms_for_user_page(self.phone)
  end
end
