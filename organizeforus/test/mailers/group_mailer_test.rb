require "test_helper"

class GroupMailerTest < ActionMailer::TestCase
  test "group_created" do
    mail = GroupMailer.group_created
    assert_equal "Group created", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
