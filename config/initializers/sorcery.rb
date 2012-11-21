Rails.application.config.sorcery.submodules = [
  :remember_me,
  :reset_password,
  :user_activation,
  :activity_logging,
  :brute_force_protection,
  :session_timeout
]

Rails.application.config.sorcery.configure do |config|
  config.user_config do |user|
    user.activation_mailer_disabled = true
    user.reset_password_mailer_disabled = true
    user.unlock_token_mailer_disabled = true
  end
  config.user_class = Coursewareable::User
end
