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
          param_ref ref("../other_node")

          node :child_1
          node :child_2
        end

        node :other_node 

        node :node_man_json do
          json { |j| j[:name] = name }
        end
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
    get "group/node_man_json.json" 

    last_response.header['Content-Type'].should eql("application/json")
    last_response.body.should ==  '{"name":"node_man_json"}'
  end

end


