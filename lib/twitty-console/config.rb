require 'yaml'

module TwittyConsole
  class Config
    def self.setup
      file = File.join(ENV['HOME'], '.twitty-console')
      conf = YAML.load_file(file)
      
      user = conf['twitter']['user']
      pass = conf['twitter']['password']

      ActiveResource::Base.site = "https://#{user}:#{pass}@twitter.com"
      
      if conf['proxy']
        proxy_host = conf['proxy']['host']
        proxy_port = conf['proxy']['port']
        proxy_user = conf['proxy']['user']
        proxy_pass = conf['proxy']['password']
        
        ActiveResource::Connection.proxy_host = proxy_host
        ActiveResource::Connection.proxy_port = proxy_port
        ActiveResource::Connection.proxy_user = proxy_user
        ActiveResource::Connection.proxy_password = proxy_pass
      end
    end
  end
end
