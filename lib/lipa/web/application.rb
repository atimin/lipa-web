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
    class Application
      def initialize(tree)
        @tree = tree
      end

      def call(env)
        @node = @tree[env['PATH_INFO']]
        if @node
          [
            200, 
            {"Content-Type" => "text/html"}, 
            [
              view(@node)
            ]
          ] 
        else
          [ 500,
            
            {"Content-Type" => "text/html"}, 
            [
              "Node is not existence"
            ]
          ]
        end
      end

      private
      def view(node)
        def node.context
          instance_eval("def binding_for(#{attrs.keys.join(",")}) binding end")
          block = block_given? ? Proc.new : nil
          binding_for(*attrs.values, &block)
        end

        if node.html
          case node.html[:render]
          when :erb
            template = read_template(node.html[:template])
            if node.tree.layout
              layout = read_template(File.join(node.tree.dir_templates, node.tree.layout))
              ERB.new(layout).result(node.context { ERB.new(template).result(node.context) })
            else
              ERB.new(template).result(node.context)
            end
          when :text
            node.html[:msg]
          end
        else
          ERB.new(read_template).result(node.context)
        end
      end

      def read_template(path = nil)
        path ||= File.join(File.dirname(__FILE__),'templates', 'node.html.erb') # default path
        File.open(path).read
      end
    end
  end
end
