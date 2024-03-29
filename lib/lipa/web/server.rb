=begin
Web access to Lipa

Copyright (c) 2011 Aleksey Timin

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
=end

require "lipa"
require "rack"

module Lipa
  module Web 
    module Server 
      # Run HTTP server
      # 
      # @param port [Integer] listener port (default 9292)
      # @param host [String] host of server (default 127.0.0.1)
      # @param server [Symbol,String] server name (:webbrick, :thin, :cgi and everything what Rack supports) ( default :webrick)
      # @param debug [Boolean] debug mode (default false)
      # @param views [String] path to views directory (default "./views")
      #
      # @example
      #   srv root :srv do
      #     # Server params
      #     port 3456
      #     host '127.0.0.1'
      #     server :webrick
      #     debug false
      #   end
      #
      #   srv.run!
      def run!
        Rack::Server.start :app => Application.new(self),
          :Port => port, 
          :server => server.to_s,
          :debug => debug
      end    
    end
  end
end
