require File.join(File.dirname(__FILE__), "..", "spec_helper")

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
          param_time Time.new(2000,"jan",1,20,15,1,0)
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

        node :node_man_html do
          html { |h| h[:body] = "<h1>Hello</h1>" }
        end
      end
    end
  end

  def app
    Lipa::Web::Application.new(@srv)
  end

  it 'should render default html template' do
    get "/group/test_node" 
    
    last_response.header['Content-Type'].should eql( "text/html")
    last_response.body.gsub(/^\s*\n/, '').should == fixture("node.html")
  end

  it 'should render custom html template' do
    get "/group/node_with_template" 
    
    last_response.header['Content-Type'].should eql("text/html")
    last_response.body.gsub(/^\s*\n/, '').should == fixture("node_with_template.html")
  end

  it 'should render text' do
    get "/group/node_greater" 
    
    last_response.header['Content-Type'].should eql("text/plain")
    last_response.body.should == "Hello world!"
  end


  it 'should have custom html response' do
    get "group/node_man_html" 

    last_response.header['Content-Type'].should eql("text/html")
    last_response.body.should ==  '<h1>Hello</h1>'
  end
end


