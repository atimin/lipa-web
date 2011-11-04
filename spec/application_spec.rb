require "lipa/web"
require "rack/test"

describe Lipa::Web::Application do
  include Rack::Test::Methods

  before :each do
    @srv = root :srv do  
      views File.join(File.dirname(__FILE__), "views")
      layout  "layout.html.erb"

      node :group do
        node :test_node do 
          param_int 20
          param_bool false
          param_float 32.2
          param_string "Hello"
          param_time Time.new(2000,"jan",1,20,15,1)
          param_proc run{5+3}
          param_ref ref("../node_with_template")

          node :child_1
          node :child_2
        end

        node :node_with_template do 
          html erb("./my_template.html.erb")
        end

        node :node_greater do 
          html text("Hello world!")
        end
      end
    end
  end

  def app
    Lipa::Web::Application.new(@srv)
  end

  it 'should get good to root' do
    get "/"
    last_response.should be_ok
  end

  it 'should get good response' do
    get "/group"
    last_response.should be_ok
  end

  it 'should get error for nonexistence node' do
    get "/nonexistence_node"
    last_response.should_not be_ok
    last_response.status.should eql(500)
    last_response.body.should eql("Node is not existence")
  end

  it 'should render default html template' do
    get "/group/test_node" 
    
    last_response.header['Content-Type'].should eql( "text/html")
    last_response.body.gsub(/^\s*\n/, '').should == fixture("node.html")
  end

  it 'should render user html template' do
    get "/group/node_with_template" 
    
    last_response.header['Content-Type'].should eql("text/html")
    last_response.body.gsub(/^\s*\n/, '').should == fixture("node_with_template.html")
  end

  it 'should render text' do
    get "/group/node_greater" 
    
    last_response.header['Content-Type'].should eql("text/plain")
    last_response.body.should == "Hello world!"
  end


  def fixture(name)
    path = File.join(File.dirname(__FILE__), "fixtures", name)
    File.open(path).read.gsub(/^\s*\n/,'')
  end
end


