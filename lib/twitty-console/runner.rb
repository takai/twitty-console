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

module TwittyConsole
  class Runner
    def self.run
      TwittyConsole::Config.setup

      rate = TwittyConsole::Account.rate_limit_status
      interval = 3600 / rate

      cui = TwittyConsole::CUI.new
      cui.handler = TwittyConsole::PostHandler.new

      threads = []
      threads << Thread.start do
        loop do
          statuses = TwittyConsole::Status.friends_timeline
          for status in statuses.sort_by{|s| s.created_at }
            cui.print status
          end
          sleep interval
        end
      end
      threads << Thread.start do
        cui.start
      end
      threads.each do |t|
        t.join
      end
    ensure
      cui.stop if cui
    end
  end
end
