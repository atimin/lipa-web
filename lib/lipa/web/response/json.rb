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
module Lipa
  module Web
    module Response
      module JSON
        def self.response(node)
          body = if node.json
                   j = {}
                   node.json[:block].call(j)
                   j.to_json
                 else
                   render_default_json(node) 
                 end

          [ 200, { "Content-Type" => "application/json" }, [body]]
        end

        private
        def self.render_default_json(node)
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

        def self.json_link_to(node)
          { :name => node.name, :full_name => node.full_name }
        end
      end
    end
  end
end
