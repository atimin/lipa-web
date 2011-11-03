$:.unshift File.join(File.dirname(__FILE__),'../lib')
require "lipa/web"

#Configuration
srv = config :server do 
  node :message do 
    html text("Hello World!")
  end
end

srv.run!

#Open http://127.0.0.1:9292/message
