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

      # Assignment erb template fot html response
      # 
      # @param path [String] path about views directory 
      #
      # @examnple
      #   node :page_1 do
      #     html erb("page.html.erb")
      #   end
      def erb(path)
        { :render => :erb, :template => File.join(root.attrs[:views], path) }
      end

      # Assignment text for html response
      # 
      # @param msg [String] text message
      #
      # @examnple
      #   node :page_1 do
      #     html text("Hello World!")
      #   end
      def text(msg)
        { :render => :text, :msg => msg }
      end

      # Definition html response 
      #
      # @see NodeHelpers#erb
      # @see NodeHelpers#text
      def html(opts=nil,&block)
        if block_given?
          @html = {:block => block}
        else
          if opts.nil?
            @html
          else
            @html = opts
          end
        end
      end

      # Definition json response
      #
      # @example
      #   node :josn_1 do
      #     json { |j| j[:name] = name }
      #   end
      #   # => { "name":"json_1" }
      def json(&block)
        if block_given?
          @json = {:block => block}
        else
          @json 
        end
      end
    end
  end
end
