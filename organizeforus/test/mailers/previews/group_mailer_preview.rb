# Preview all emails at http://localhost:3000/rails/mailers/group_mailer
class GroupMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/group_mailer/group_created
  def group_created
    GroupMailer.group_created
  end

end
