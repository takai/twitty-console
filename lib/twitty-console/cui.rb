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

require 'cgi'
require 'iconv'
require 'readline'
require 'term/ansicolor'

module TwittyConsole #:nodoc:
  class CUI
    include Term::ANSIColor

    @@encoding = 'UTF-8'

    PROMPT = '> '
    attr_writer :handler

    def self.encoding= encoding
      @@encoding = encoding
    end

    def output statuses
      puts
      statuses.each do |status|
        screen_name = status.user.screen_name
        text = Iconv.conv(@@encoding, 'UTF-8', status.text)
        text = CGI.unescapeHTML(text)
        
        puts "%s: %s" % [blue(screen_name), text]
      end
      prompt
    end
    
    def warn message
      puts
      puts red(message)
      prompt
    end
    
    def start
      while text = Readline.readline(PROMPT, true)
        @handler.handle(Iconv.conv('UTF-8', @@encoding, text))
      end
    end
    
    def stop
    end

    def prompt
      print PROMPT
      STDOUT.flush
      Readline.refresh_line
    end
  end
end
