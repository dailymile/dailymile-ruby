# 
# HACK: monkey-patching oauth2 lib
# 
module OAuth2
  class AccessToken
    def request(verb, path, params = {}, headers = {})
      params = params.merge('oauth_token' => @token) unless @token.nil?
      @client.request(verb, path, params)
    end
  end
end