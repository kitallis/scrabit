require 'rubygems'
require 'gtk2'

def main
  status = Gtk::StatusIcon.new
  status.stock = Gtk::Stock::ADD
  status.tooltip = "Scrabit"
  status.signal_connect('activate') { on_activate }
  status.signal_connect('popup-menu') {|statusicon, button, time| on_right_click statusicon, button, time }
  menu = Gtk::Menu.new
  menu.append(scrab = Gtk::ImageMenuItem.new(GTK::Stock::INFO))
  menu.append(fulls = Gtk::ImageMenuItem.new(GTK::Stock::INFO))
  menu.append(preferences = Gtk::ImageMenuItem.new(Gtk::Stock::PREFERENCES))
  menu.append(Gtk::SeparatorMenuItem.new)
  menu.append(about = Gtk::ImageMenuItem.new(Gtk::Stock::ABOUT))
  menu.append(quit = Gtk::ImageMenuItem.new(Gtk::Stock::QUIT))
  scrab.signal_connect('activate') { on_click_scrab }
  fulls.signal_connect('activate') { on_click_fulls }
  preferences.signal_connect('activate') { on_click_preferences }
  about.signal_connect('activate') { on_click_about }
  quit.signal_connect('activate') { Gtk.main_quit }
  Gtk.main
end

#def on_click_preferences
#  PreferencesWindow.new("Preferences").show_all
#end

def on_click_scrab
  `import upload_buffer.png`
  url = `curl -F "img=@upload_buffer.png;type=image/png" http://scrabit.appspot.com/posthere`
  `notify-send -u critical http://scrabit.appspot.com/#{url}`
  `rm upload_buffer.png`
end	

def on_activate
  window ||= Proc.new { window = Window.new; window.signal_connect('destroy') { window = nil }; puts "#{window}"; window }.call
end

def on_click_about
  Gtk::AboutDialog.new.show_all
end

def on_right_click(statusicon, button, time)
  menu.popup(nil, nil, button, time) {|menu, x, y, push_in| status.position_menu(menu)}
  menu.show_all
end

main()
