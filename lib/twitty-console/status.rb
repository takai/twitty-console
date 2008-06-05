require 'activeresource'

module TwittyConsole
  APPLICATION_NAME = 'TwittyConsole'

  class Status < ActiveResource::Base
    @@previous_statuses = []
    
    def self.friends_timeline
      statuses = self.find(:all, :from => '/statuses/friends_timeline.xml')
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
end
