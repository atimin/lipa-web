require "lipa/web"
require "rack/test"

def fixture(name)
  path = File.join(File.dirname(__FILE__), "fixtures", name)
  File.open(path).read.gsub(/^\s*\n/,'')
end

def example_node
  node :group do
    node :test_node do 
      param_int 20
      param_bool false
      param_float 32.2
      param_string "Hello"
      param_time Time.new(2000,"jan",1,20,15,1,0)
      param_proc run{5+3}
      param_ref ref("../other_node")

      node :child_1
      node :child_2
    end

    node :other_node 
  end
end
