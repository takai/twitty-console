require 'ncurses'

module TwittyConsole #:nodoc:
  class CUI
    attr_writer :handler

    def initialize
      initialize_ncurses
      initialize_display_window
      initialize_form_window
    end

    def print status
      screen_name = status.user.screen_name
      text = status.text
      
      @display_window.attrset(Ncurses.COLOR_PAIR(1))
      @display_window.addstr("#{screen_name}: ")
      
      @display_window.attrset(Ncurses.COLOR_PAIR(2))
      @display_window.addstr(text)
      @display_window.addstr("\n")

      @display_window.refresh
    end

    def start
      buf = ""
      loop do
        case c = @form_window.getch
        when -1
        when 10 # "\n"
          @handler.handle buf
          reset_form_window
          buf = ""
        else
          buf << c.chr
        end
        sleep 0.01
      end
    end

    def stop
      Ncurses.endwin
    end

    private
    def initialize_ncurses
      Ncurses.initscr
      Ncurses.start_color
      Ncurses.cbreak

      Ncurses.init_pair(1, Ncurses::COLOR_CYAN,  Ncurses::COLOR_BLACK);
      Ncurses.init_pair(2, Ncurses::COLOR_WHITE, Ncurses::COLOR_BLACK);
    end

    def initialize_display_window
      @display_window = Ncurses::WINDOW.new(Ncurses.LINES - 1, Ncurses.COLS, 0, 0)
      @display_window.idlok(true)
      @display_window.scrollok(true)
      @display_window.move(0, 0)
      @display_window.noutrefresh
    end

    def initialize_form_window
      @form_window = Ncurses::WINDOW.new(1, Ncurses.COLS, Ncurses.LINES - 1, 0)
      @form_window.nodelay(true)
      @form_window.move(0, 0)
      @form_window.addstr("> ")
      @form_window.refresh
    end

    def reset_form_window
      @form_window.erase
      @form_window.move(0, 0)
      @form_window.addstr("> ")
      @form_window.refresh
    end
  end
end
