# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the home\s?page$/
      '/'
    when /^Create New Event page/
      new_event_path
    when /^the Event page/
       events_path

    when /^Log in page/
      new_user_session_path

    when /^Home page/
      root_path


    when /^Create group page/
      new_group_path

    when /^Registration page/
      new_user_registration_path

    when /^Post1 page/
      group_post_path(Group.find(10),Post.find(12))

    when /^Survey creation path/
      new_survey_path(Group.find(10),Group.find(10).user)

    when /^Edit group page/
      edit_group_path(Group.find(10))
    
    when /^the Group homepage/
      group_path(Group.find(10))

     
    when /^the Group2 homepage/
      group_path(Group.find(9))


    
    

    when /^Google provider authentication/
      'https://accounts.google.com/o/oauth2/auth/oauthchooseaccount?access_type=offline&client_id=304187077726-5sschkps49r21ljqe2fc1tqhb83u09rk.apps.googleusercontent.com&prompt=consent&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fusers%2Fauth%2Fgoogle_oauth2%2Fcallback&response_type=code&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.profile%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuser.birthday.read%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcalendar&state=71a0e94a792893420b7e5c8dd8870937648247fbfefbaf89&flowName=GeneralOAuthFlow'

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
