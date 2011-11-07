require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Lipa::Web::Application do
  include Rack::Test::Methods

  before :each do
    @srv = root :srv do  
      views File.join(File.dirname(__FILE__), "views")
      layout  "layout.html.erb"

      example_node

      node :node_with_template do 
        html erb("./my_template.html.erb")
      end

      node :node_greater do 
        html text("Hello world!")
      end

      node :node_man_html do
        say "Hello"
        html { "<h1>#{say}</h1>" }
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
    get "/node_with_template" 
    
    last_response.header['Content-Type'].should eql("text/html")
    last_response.body.gsub(/^\s*\n/, '').should == fixture("node_with_template.html")
  end

  it 'should render text' do
    get "/node_greater" 
    
    last_response.header['Content-Type'].should eql("text/plain")
    last_response.body.should == "Hello world!"
  end


  it 'should have custom html response' do
    get "/node_man_html" 

    last_response.header['Content-Type'].should eql("text/html")
    last_response.body.should ==  '<h1>Hello</h1>'
  end
end


