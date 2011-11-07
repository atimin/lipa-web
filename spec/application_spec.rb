require File.join(File.dirname(__FILE__), "spec_helper")

describe Lipa::Web::Application do
  include Rack::Test::Methods

  before :each do
    @srv = root :srv do  
      views File.join(File.dirname(__FILE__), "views")
      layout  "layout.html.erb"

      node :group do
        node :test_node do 
          node :child_1
          node :child_2
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
end


