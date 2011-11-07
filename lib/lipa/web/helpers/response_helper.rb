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

require "json"
require "builder"

module Lipa
  module Web
     module ResponseHelper
       # Rendering node data in format
       # 
       # @param node [Lipa::Node] node for rendering
       # @param format of rendering 
      def respond(node, format)
        case format.to_s 
        when "json"
          json_format(node)
        when "xml"
          xml_format(node)
        else
          html_format(node)
        end
      end

      private
      def context(node)
        node.instance_eval("def binding_for(#{node.attrs.keys.join(",")}) binding; end")
        node.extend(HtmlHelper)
        block = block_given? ? Proc.new : nil
        node.binding_for(*node.eval_attrs.values, &block)
      end

      def read_template(path)
        File.open(path).read
      end

      def default_template
        path = File.join(File.dirname(__FILE__), '..', 'views', 'node.html.erb') # default path
        read_template(path)
      end

      def render_erb(node)
        template = read_template(node.html[:template])
        root = node.root
        if root.layout
          layout = read_template(File.join(root.views, root.layout))
          ERB.new(layout).result(context(node) { ERB.new(template).result(context(node)) })
        else
          ERB.new(template).result(context(node))
        end
      end

      def html_format(node)
        status = 200
        header = {}
        body = ""
        
        html = node.html
        if html
          if html[:block]
            h = { :status => 200, :header => { "Content-Type" => "text/html" }}
            h[:body] ||= html[:block].call(h)
            status, header, body = h[:status], h[:header], h[:body]
          else
            case html[:render]
            when :erb
              body = render_erb(node)
              header["Content-Type"] = "text/html"
            when :text
              body = html[:msg]
              header["Content-Type"] = "text/plain"
            end
          end
        else
          body = ERB.new(default_template).result(context(node)) 
        end

        [ status, header, [body]]
      end

      def json_format(node)
        status = 200
        header = {}
        body = ""

        if node.json
          j = {}
          node.json[:block].call(j)
          body = j.to_json
        else
          body = render_default_json(node) 
        end

        header["Content-Type"] = "application/json"
        [ status, header, [body]]
      end

      def render_default_json(node)
        j = {}
        j[:name] = node.name    
        j[:full_name] = node.full_name
        j[:parent] = json_link_to(node.parent)
        j[:children] = node.children.values.each.map {|ch| json_link_to(ch) }
        node.eval_attrs.each_pair do |k,v|
         j[k] = v.kind_of?(Lipa::Node) ? json_link_to(v) : v
        end

        j.to_json
      end

      def json_link_to(node)
        { :name => node.name, :full_name => node.full_name }
      end

      def xml_format(node)
        status = 200
        header = {}
        body = ""

        template = if node.xml
          case node.xml[:render]
          when :builder
          read_template(node.xml[:template])
          end
        else
          path = File.join(File.dirname(__FILE__), '..', 'views', 'node.builder') # default path
          read_template(path)
        end

        xml = Builder::XmlMarkup.new        
        xml.instance_eval(template)
        body = xml.target!
        
        header["Content-Type"] = "application/xml"
        [status, header, [body]]
      end
    end
  end
end
