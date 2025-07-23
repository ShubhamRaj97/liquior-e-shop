class UserSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :username, :email


  attribute :roles do |object, _params|
    object.roles.pluck(:name)
  end
end