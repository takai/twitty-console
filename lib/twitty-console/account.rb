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
  class Account < ActiveResource::Base
    def self.rate_limit_status
      url = '/account/rate_limit_status.' + self.connection.format.extension
      hash = connection.get(url, headers)
      rate = hash['hourly_limit']
      rate.to_i
    rescue
      60
    end
  end
end
