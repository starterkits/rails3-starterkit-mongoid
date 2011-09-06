module OauthProvider::User

  def apply_oauth_data(oauth_data, opts = {})
    opts.reverse_merge!(set_if_blank: true)

    provider = Provider::provider_class(oauth_data['provider'])
    data = provider.normalize_oauth(oauth_data)

    self.username       = data[:username]         if field_needs_data?(:username, opts)
    self.email          = data[:email]            if field_needs_data?(:email, opts)
    self.name           = data[:name]             if field_needs_data?(:name, opts)
    self.first_name     = data[:first_name]       if field_needs_data?(:first_name, opts)
    self.last_name      = data[:last_name]        if field_needs_data?(:last_name, opts)
    self.nickname       = data[:nickname]         if field_needs_data?(:nickname, opts)
    self.bio            = data[:bio]              if field_needs_data?(:bio, opts)
    self.image_url      = data[:image_url]        if field_needs_data?(:image_url, opts)
    self.location_name  = data[:location_name]    if field_needs_data?(:location_name, opts)
    self.verified       = data[:verified]         if field_needs_data?(:verified, set_if_blank: false)

    # set nickname to something user will recognize when displayed in the UI
    data[:nickname] = data[:nickname].presence || data[:username].presence || data[:name].presence || data[:first_name].presence
    auth_data = data.slice(
      :provider_type, :uid, :username, :nickname, :token, :secret, :expires, :profile_url, :image_url
    ).merge(oauth_data: oauth_data.to_json)

    authentications.build(auth_data)
  end

  protected

  def field_needs_data?(field, opts)
    self.respond_to?(field) && self.send(field).send(opts[:set_if_blank] ? 'blank?' : 'nil?')
  end
end
