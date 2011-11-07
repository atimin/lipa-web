require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Lipa::Web::Application do
  include Rack::Test::Methods

  before :each do
    @srv = root :srv do  
      views File.join(File.dirname(__FILE__), "views")

      example_node

      node :node_with_template do 
        xml builder("my_template.builder")
      end
    end
  end

  def app
    Lipa::Web::Application.new(@srv)
  end

  it 'should have default xml response' do
    get "group/test_node.xml" 

    last_response.header['Content-Type'].should eql("application/xml")
    last_response.body.gsub(/\s*/,'').should == fixture("node.xml").gsub(/\s*/,'')
  end

  it 'should render custom xml template' do
    get "/node_with_template.xml" 
    
    last_response.header['Content-Type'].should eql("application/xml")
    last_response.body.gsub(/\s*/, '').should == fixture("node_with_template.xml").gsub(/\s*/,'')
  end


end

