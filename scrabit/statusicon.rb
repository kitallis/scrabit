# a PanelApplet _might_ be more appropriate, but i'm really not sure about this right now. I Guess it'll depend on how my
# installation procedure spans out. 

module Scrabit
  class StatusIcon
    def initialize
      @status = Gtk::StatusIcon.new
      @status.pixbuf = Gdk::Pixbuf.new(Icon)
      @status.tooltip = "Scrabit"
      @status.signal_connect('activate') { on_activate }
      @status.signal_connect('popup-menu') {|statusicon, button, time| on_right_click statusicon, button, time }
      @menu = Gtk::Menu.new
      # haven't figured out how to name the ImageMenuItem, too tired to look up the doc
      # will implement fullscreen and globalize the common Scrab code after the above is done  	
      @menu.append(scrab = Gtk::ImageMenuItem.new(Gtk::Stock::MEDIA_RECORD))
      # @menu.append(full = Gtk::ImageMenuItem.new(Gtk::Stock::FULLSCREEN))
      @menu.append(preferences = Gtk::ImageMenuItem.new(Gtk::Stock::PREFERENCES))
      @menu.append(about = Gtk::ImageMenuItem.new(Gtk::Stock::ABOUT))
      @menu.append(Gtk::SeparatorMenuItem.new)
      @menu.append(quit = Gtk::ImageMenuItem.new(Gtk::Stock::QUIT))
      scrab.signal_connect('activate') { on_click_scrab }
      # full.signal_connect('activate') { on_click_full }
      preferences.signal_connect('activate') { on_click_preferences }
      about.signal_connect('activate') { on_click_about }
      quit.signal_connect('activate') { Gtk.main_quit }	
      @save = Gtk::Clipboard.get(Gdk::Selection::CLIPBOARD)
      # for an authenticated setup, will need to inherit details from PreferencesWindow class
      params = {'username' => '', 'password' => ''}  
      @post_data = params.map {|k, v| Curl::PostField.content(k, v)} 	
    end

    # using curb (libcurl(3)), more control
    def on_click_scrab
      begin 
        `import upload_buffer.png` 
      rescue 
       	puts "ImageMagick error"
	raise
      end
      @post_data << Curl::PostField.file('', 'upload_buffer.png')
      Uri.multipart_form_post = true
      Uri.http_post(*@post_data)
      url = "http://scrabit.appspot.com/#{Uri.body_str}"
      @save.set_text("#{url}")
      begin
        `notify-send "Your image has been successfully uploaded : #{url}"`
      rescue
	puts "notify-send library error"
      else
	puts "Notification sent"	
      ensure # that the url is copied in the clipboard
	puts "Copied to clipboard"
	@save.set_text("#{url}")
      end
      FileUtils.rm %w( upload_buffer.png )
    end

    # will start working on, when the GAE setup works	
    def on_click_preferences
      prefs = PreferencesWindow.new("Preferences")
      prefs.show_all
    end

    def on_activate
      @window ||= Proc.new { window = Window.new; window.signal_connect('destroy') { @window = nil }; puts "#{@window}"; window }.call
    end

    # need to improve to make it look like the standard GNOME-About, maybe call a Glade designed .ui file from here
    def on_click_about
      Gtk::AboutDialog.new.show_all
    end

    def on_right_click(statusicon, button, time)
      @menu.popup(nil, nil, button, time) {|menu, x, y, push_in| @status.position_menu(@menu)}
      @menu.show_all
    end
  end
end
