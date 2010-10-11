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
  class Client
    def request(verb, url, params = {}, headers = {})
      if verb == :get
        connection.run_request(verb, url, nil, headers) do |req|
          req.params.update(params)
        end
      else
        connection.run_request(verb, url, params, headers)
      end
    end
  end
end