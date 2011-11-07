require "lipa/web"
require "rack/test"

def fixture(name)
  path = File.join(File.dirname(__FILE__), "fixtures", name)
  File.open(path).read.gsub(/^\s*\n/,'')
end

