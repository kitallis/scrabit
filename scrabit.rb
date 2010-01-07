$LOAD_PATH.unshift File.dirname(__FILE__)

module Scrabit
  require 'gtk2'
  require 'fileutils'	
  require 'rubygems'
  require 'curb'
  require 'scrabit/statusicon'
  require 'scrabit/preferences'
  def self.Main
    StatusIcon.new
    Gtk.main
  end
  Icon = "icons/panel.png"
  Uri = Curl::Easy.new("http://scrabit.appspot.com/posthere")
end

if __FILE__ == $0
  Scrabit.Main
end
