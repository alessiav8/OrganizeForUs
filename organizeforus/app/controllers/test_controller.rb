class TestController < ActionController::TestCase

include Devise::Test::ControllerHelpers

def setup
    @request.env["devise.mapping"]= Devise.mapping[:user]
    sign_in FactoryBot.create(:user)
end
end