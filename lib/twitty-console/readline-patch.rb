require 'readline'
require 'dl/import'

module Readline
  module LIBREADLINE
    if RUBY_VERSION < '1.9.0'
      extend DL::Importable
    else 
      extend DL::Importer
    end

    case RUBY_PLATFORM
    when /mswin(?!ce)|mingw|cygwin|bccwin/
      dlload 'readline.dll'
    when /darwin/
      dlload 'libreadline.dylib'
    else
      dlload 'libreadline.so'
    end
    extern 'int rl_refresh_line(int, int)'
  end

  def self.refresh_line
    LIBREADLINE.rl_refresh_line(0, 0)
  end
end
