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

module Lipa
  module Web
    module NodeHelper
      def erb(path)
        { :render => :erb, :template => File.join(root.attrs[:views], path) }
      end

      def text(msg)
        { :render => :text, :msg => msg }
      end

      def html(opts=nil)
        if opts.nil?
          @html
        else
          @html = opts
        end
      end

      def link_to(node)
        %(<a href="#{node.full_name}">#{node.name}</a>)
      end

      def view
        def context(node=self)
          block = block_given? ? Proc.new : nil
          binding(&block)
        end

        if html
          case html[:render]
          when :erb
            template = read_template(html[:template])
            if root.layout
              layout = read_template(File.join(root.views, root.layout))
              ERB.new(layout).result(context { ERB.new(template).result(context) })
            else
              ERB.new(template).result(context)
            end
          when :text
            html[:msg]
          end
        else
          ERB.new(read_template).result(context)
        end
      end

      private
      def read_template(path = nil)
        path ||= File.join(File.dirname(__FILE__),'views', 'node.html.erb') # default path
        File.open(path).read
      end
    end
  end
end
