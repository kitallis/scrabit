module Scrabit
  class PreferencesWindow < Gtk::Window
    def initialize(name)
      super name
        set_title(name)
        signal_connect('destroy') { self.destroy } 
        init_UI
        show_all
    end
    def init_UI
      fixed = Gtk::Fixed.new
      add(fixed)
      button = Gtk::Button.new("Quit")
      button.set_size_request(80, 35)      
      button.signal_connect('clicked') { self.destroy } 
      fixed.put(button, 60, 50)       
      set_default_size(200, 160)
      set_window_position Gtk::Window::POS_CENTER
    end
  end
end


