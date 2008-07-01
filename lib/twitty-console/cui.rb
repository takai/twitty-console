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

require 'ncurses'

module TwittyConsole #:nodoc:
  MAX_SIZE = 140

  class CUI
    attr_writer :handler

    def initialize
      @clipboard = ''
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

    def warn message
      @display_window.attrset(Ncurses.COLOR_PAIR(3))
      @display_window.addstr(message)
      @display_window.addstr("\n")

      @display_window.refresh
    end

    def start
      loop do
        case c = @form_window.getch
        when -1
        when ?\n, ?\r, ?\C-m
          @input_form.form_driver(Ncurses::Form::REQ_BEG_LINE);
          text = @input_field.field_buffer(0)
          text.strip!
          @handler.handle text unless text.empty?
          @input_form.form_driver(Ncurses::Form::REQ_CLR_FIELD);
        when Ncurses::KEY_BACKSPACE, ?\C-h
          @input_form.form_driver(Ncurses::Form::REQ_DEL_PREV);
        when ?\C-d
          @input_form.form_driver(Ncurses::Form::REQ_DEL_CHAR);
        when Ncurses::KEY_LEFT, ?\C-b
          @input_form.form_driver(Ncurses::Form::REQ_PREV_CHAR);
        when Ncurses::KEY_RIGHT, ?\C-f
          @input_form.form_driver(Ncurses::Form::REQ_NEXT_CHAR);
        when ?\C-a
          @input_form.form_driver(Ncurses::Form::REQ_BEG_LINE);
        when ?\C-e
          @input_form.form_driver(Ncurses::Form::REQ_END_LINE);
        when ?\C-k
          @input_form.form_driver(Ncurses::Form::REQ_CLR_EOL);
        else
          @input_form.form_driver(c)
        end
        sleep 0.01
      end
    end

    def stop
      @input_form.unpost_form
      @input_form.free_form
      @input_field.free_field
      Ncurses.endwin
    end

    private
    def initialize_ncurses
      Ncurses.initscr
      Ncurses.start_color
      Ncurses.cbreak
      Ncurses.noecho

      Ncurses.init_pair(1, Ncurses::COLOR_CYAN,  Ncurses::COLOR_BLACK);
      Ncurses.init_pair(2, Ncurses::COLOR_WHITE, Ncurses::COLOR_BLACK);
      Ncurses.init_pair(3, Ncurses::COLOR_RED, Ncurses::COLOR_BLACK);
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
      @form_window.keypad(true)
      @form_window.nodelay(true)

      @input_field = Ncurses::Form::FIELD.new(1, Ncurses.COLS - 2, 0, 2, 0, 0)
      @input_field.set_max_field(TwittyConsole::MAX_SIZE)

      @input_form = Ncurses::Form::FORM.new([@input_field])
      @input_form.set_form_win(@form_window)
      @input_form.post_form

      @form_window.mvprintw(0, 0, "> ")
      @form_window.refresh
    end
  end
end
