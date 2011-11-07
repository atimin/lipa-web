require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Lipa::Web::Application do
  include Rack::Test::Methods

  before :each do
    @srv = root :srv do  
      example_node
    end
  end

  def app
    Lipa::Web::Application.new(@srv)
  end

  it 'should have default json response' do
    get "group/test_node.xml" 

    last_response.header['Content-Type'].should eql("application/xml")
    last_response.body.gsub(/\s*/,'').should == fixture("node.xml").gsub(/\s*/,'')
  end
end

