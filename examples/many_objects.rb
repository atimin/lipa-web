$:.unshift File.join(File.dirname(__FILE__),'../lib')
require "lipa/web"

srv = root :srv do 
  kind :group do
    count run{
      c = 0
      children.values.each do |ch|
        c += if ch.kind == :group
               ch.count
             else
               1
             end
      end
      c
    }
  end

  kind :object do
    size 0
    location "somethere"
    any_attrs "..."
  end

  group :group_1 do 
    #make ten object
    (1...10).each do |i|
      object "object_#{i}"
    end
  end
end

srv.run!
