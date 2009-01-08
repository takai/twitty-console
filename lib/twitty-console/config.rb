#  Copyright 2008 Naoto Takai
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

require 'yaml'

module TwittyConsole
  class Config
    def self.setup
      file = File.join(ENV['HOME'], '.twitty-console')
      conf = YAML.load_file(file)
      
      user = conf['twitter']['user']
      pass = conf['twitter']['password']
      site = conf['twitter']['site'] || 'twitter.com'
      prot = conf['twitter']['protocol'] || 'https'
      frmt = conf['twitter']['format'] || 'xml'

      ActiveResource::Base.site = "#{prot}://#{user}:#{pass}@#{site}"
      ActiveResource::Base.format = frmt.to_sym
      ActiveResource::Base.logger = Logger.new(STDERR) if $DEBUG
      
      if conf['proxy']
        proxy_host = conf['proxy']['host']
        proxy_port = conf['proxy']['port']
        proxy_user = conf['proxy']['user']
        proxy_pass = conf['proxy']['password']
        
        ActiveResource::Connection.proxy_host = proxy_host
        ActiveResource::Connection.proxy_port = proxy_port
        ActiveResource::Connection.proxy_user = proxy_user
        ActiveResource::Connection.proxy_password = proxy_pass
        
        if conf['cui']
          TwittyConsole::CUI.encoding = conf['cui']['encoding']
        end
      end
    end
  end
end
