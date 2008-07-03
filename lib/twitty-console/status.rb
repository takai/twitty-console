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

require 'activeresource'

module TwittyConsole
  APPLICATION_NAME = 'twittyconsole'

  class Status < ActiveResource::Base
    @@previous_statuses = []
    
    def self.friends_timeline
      url = '/statuses/friends_timeline.' + self.connection.format.extension
      statuses = self.find(:all, :from => url)
      updated_statuses = statuses - @@previous_statuses
      @@previous_statuses = statuses
      
      updated_statuses
    end

    def update
      self.class.post(:update,
                      :status => self.status,
                      :source => TwittyConsole::APPLICATION_NAME)
    end
  end

  class User < ActiveResource::Base
  end
end
