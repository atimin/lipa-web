require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Lipa::Web::Application do
  include Rack::Test::Methods

  before :each do
    @srv = root :srv do  
      example_node

      node :node_man_json do
        json { |j| j[:name] = name }
      end
    end
  end

  def app
    Lipa::Web::Application.new(@srv)
  end

  it 'should have default json response' do
    get "group/test_node.json" 

    last_response.header['Content-Type'].should eql("application/json")
    last_response.body.gsub(/\s*/,'').should == fixture("node.json").gsub(/\s*/,'')
  end

  it 'should have custom json response' do
    get "node_man_json.json" 

    last_response.header['Content-Type'].should eql("application/json")
    last_response.body.should ==  '{"name":"node_man_json"}'
  end

end


