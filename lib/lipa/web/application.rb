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
require "erb"

module Lipa
  module Web
    # Rack application
    class Application
      include Response

      # Init app
      #
      # @param root [Lipa::Root] Lipa structure
      def initialize(root)
        @root = root
      end

      def call(env)
        path, format = env['PATH_INFO'].split(".")
        node = @root[path]
        if node
          respond(node, format)
        else
          static_path = File.join(@root.static_folder, env['PATH_INFO'])
          if File.exist?(static_path)
            [ 200, { "Content-Type" => "text/#{format}" }, [File.read(static_path)]]
          else
            [ 500,
              
              {"Content-Type" => "text/html"}, 
              [
                "Node is not existence"
              ]
            ]
          end
        end
      end

    end
  end
end
