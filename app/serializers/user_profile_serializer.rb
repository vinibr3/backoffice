class UserProfileSerializer < JSONAPI::Serializable::Resource
  type 'user_profiles'

  attributes :expire_at, :created_at, :updated_at

  belongs_to :user
  belongs_to :profile
end
