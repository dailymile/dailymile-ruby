module Dailymile
  
  class Token
    
    def initialize(client, token)
      @client = client
      set_access_token token
    end
    
    def access_token=(token)
      set_access_token token
    end
    
    def get(path, params = {})
      request :get, path, params
    end
    
    def post(path, params = {})
      request :post, path, params
    end
    
    def put(path, params = {})
      request :put, path, params
    end
    
    def delete(path)
      request :delete, path
    end
    
  private
  
    def request(verb, path, params = {}, headers = {})
      path << ".#{DEFAULT_FORMAT}" unless path =~ /.+\.\w+$/
      path << to_query_string(params) unless params.empty?
      
      response = @access_token.request(verb, path, {}, default_headers.merge(headers))
      handle_response(response)
    end
    
    def handle_response(response)
      case response.status
      when 200, 201
        JSON.parse(response.body) rescue nil
      when 404
        raise NotFound
      when 401
        raise Unauthorized
      when 403
        raise Forbidden, "Not using HTTP over TLS"
    when 503, 502
        if response.status == 503 && response['Retry-After']
          raise RateLimitExceeded
        else
          raise Unavailable, "#{response.status}: #{response.body}"
        end
      when 422
        errors = JSON.parse(response.body) rescue nil
        raise UnprocessableEntity, errors
      else
        raise DailymileError,"#{response.status}: #{response.body}"
      end
    end
    
    def to_query_string(params = {})
      '?' + params.map do |k, v|
        if v.instance_of?(Hash)
          v.map do |sk, sv|
            ["#{k}[#{sk}]", URI.escape(sv.to_s)].join('=')
          end.join('&')
        else
          [k.to_s, URI.escape(v.to_s)].join('=')
        end
      end.join('&')
    end
  
    def default_headers
      {
        'Accept' =>  'application/json',
        'User-Agent' => "dailymile-ruby/#{VERSION}"
      }
    end
    
    def set_access_token(token)
      @access_token = OAuth2::AccessToken.new(@client, token)
    end
    
  end
  
end