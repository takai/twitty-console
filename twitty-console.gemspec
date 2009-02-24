# -*- mode: ruby; coding: utf-8-unix -*-
 
Gem::Specification.new do |spec|
  spec.name = "twitty-console"
  spec.summary = "Console-based Twitter Client"
  spec.version = "0.2.0"
  spec.author = "Naoto Takai"
  spec.email = "takai@recompile.net"
  
  spec.files = %w{
    LICENSE.txt
    README.rdoc
    bin/twitty-console
    lib/twitty-console
    lib/twitty-console.rb
    lib/twitty-console/account.rb
    lib/twitty-console/config.rb
    lib/twitty-console/cui.rb
    lib/twitty-console/handler.rb
    lib/twitty-console/proxy-patch.rb
    lib/twitty-console/runner.rb
    lib/twitty-console/status.rb
    twitty-console.gemspec
  }
  spec.executables = ['twitty-console']
 
  spec.homepage = "http://github.com/takai/twitty-console/"
  spec.description = "TwittyConsole is a console based client for Twitter."
 
  spec.add_dependency('activeresource')
  spec.add_dependency('term-ansicolor')
end
