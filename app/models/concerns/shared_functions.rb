module SharedFunctions
	def editable_by_user?(user)
    created_by_user_id == user.id
  end
end
