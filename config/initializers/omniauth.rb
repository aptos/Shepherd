# removed ' rw_nus' from provider :scope with removal of linkedin share button. Once less item to scare away new users.

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_KEY"], ENV["GOOGLE_SECRET"],
  {
    name: "google_login",
		scope: "email, https://mail.google.com/, gmail.compose, gmail.modify",
    approval_prompt: '',
    access_type: "offline",
    include_granted_scopes: true
  }
end

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

