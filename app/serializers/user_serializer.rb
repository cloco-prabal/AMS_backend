class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :phone, :dob, :gender, :address,:role_id,:artist_id
  has_one :role
end
