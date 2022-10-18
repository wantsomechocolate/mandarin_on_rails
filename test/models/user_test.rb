require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user is valid with valid attributes" do
     #assert true

     #User.save()

     user_dict = {}
     user_dict[:email] = "test_email@example.com"
     user = User.new(user_dict)
     user.save
     assert user.id > 0

   end
end
