module UsersHelper
	def user_name(name)
		if name == nil
			return "(Name hidden - Privacy)"
		else
			return name
		end
	end
end
