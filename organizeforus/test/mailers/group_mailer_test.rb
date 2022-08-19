require "test_helper"

class GroupMailerTest < ActionMailer::TestCase
  test "group_created" do
     
    GroupMailer.with(group: groups(:one), user: users(:two)).group_created
  end

end
