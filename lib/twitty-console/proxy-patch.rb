module ActiveResource
  class Connection
    @@proxy_host = @@proxy_port = @@proxy_user = @@proxy_pass = nil

    def self.proxy_host= proxy_host
      @@proxy_host = proxy_host
    end
    
    def self.proxy_port= proxy_port
      @@proxy_port = proxy_port
    end
    
    def self.proxy_user= proxy_user
      @@proxy_user = proxy_user
    end
    
    def self.proxy_password= proxy_pass
      @@proxy_pass = proxy_pass
    end
    
    def http
      if @@proxy_host && @@proxy_port
        http_class = Net::HTTP::Proxy(@@proxy_host, @@proxy_port,
                                      @@proxy_user, @@proxy_pass)
      else
        http_class = Net::HTTP
      end
      http = http_class.new(@site.host, @site.port)
      http.use_ssl = @site.is_a?(URI::HTTPS)
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE if http.use_ssl
      http
    end
  end
end
