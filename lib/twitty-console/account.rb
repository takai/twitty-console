require 'activeresource'

module TwittyConsole
  class Account < ActiveResource::Base
    def self.rate_limit_status
      rate = connection.get('/account/rate_limit_status.xml', headers)
      rate.to_i
    end
  end
end
