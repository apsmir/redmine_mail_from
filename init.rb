Redmine::Plugin.register :redmine_mail_from do
  name 'Redmine Mail From plugin'
  author 'Takeshi Nakamura, Alexey Smirnov'
  description 'Extends mail "From:" header field'
  version '3.0.0'
  url 'https://github.com/apsmir/redmine_mail_from.git'
  author_url 'https://github.com/apsmir'
end

require_dependency File.dirname(__FILE__) + '/lib/redmine_mail_from/hooks'
require_dependency File.dirname(__FILE__) + '/lib/redmine_mail_from/mailer_model_patch'

Rails.application.config.after_initialize do
  unless Mailer.included_modules.include?(RedmineMailFrom::MailerModelPatch)
    Mailer.send(:prepend, RedmineMailFrom::MailerModelPatch)
  end
end
