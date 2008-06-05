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
