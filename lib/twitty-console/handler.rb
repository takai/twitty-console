module TwittyConsole
  class PostHandler
    def handle text
      TwittyConsole::Status.new(:status => text).update
    end
  end
end
