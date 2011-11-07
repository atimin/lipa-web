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

require "builder"

module Lipa
  module Web
    module Response
      module XML
        extend Helpers::Response

        def self.response(node)
          xml = Builder::XmlMarkup.new        
          if node.xml
            if node.xml[:block]
              node.xml[:block].call(xml)
            else
              case node.xml[:render]
              when :builder
                template = read_template(node.xml[:template])
              end
              eval(template, context(node,xml))
            end
          else
            eval(default_template, context(node,xml))
          end

          [200, {"Content-Type" => "application/xml"}, [ xml.target!]]
        end

        private
        def self.context(node,xml)
          node.instance_eval("def binding_for(#{(node.attrs.keys << "xml").join(",")}) binding; end")
          block = block_given? ? Proc.new : nil
          node.binding_for(*(node.eval_attrs.values << xml), &block)
        end

        def self.default_template
          path = File.join(File.dirname(__FILE__), '..', 'views', 'node.builder') # default path
          template = read_template(path)
        end
      end
    end
  end
end

