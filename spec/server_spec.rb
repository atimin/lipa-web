require "lipa/web"

describe Lipa::Web::Server do

  before :each do
    @srv = root :srv do  
      node :test_node
    end

    app = mock('Rack application')
    Lipa::Web::Application.stub!(:new).and_return(app)
    @default_opts = {
      :app => app,
      :Port => 9292,
      :server => "webrick",
      :debug => false
    }

    Rack::Server.stub!(:start).and_return(nil)
  end

  it 'should run whith default options' do
    test_server(@srv, @default_opts)
  end

  it 'should have #port option' do
    @srv.port = 9999
    test_server(@srv, @default_opts.merge(:Port => 9999))
  end

  it 'should have #server option' do
    @srv.server = 'thin'
    test_server(@srv, @default_opts.merge(:server => 'thin'))
  end

  it 'should have #debug option' do
    @srv.debug = true
    test_server(@srv, @default_opts.merge(:debug => true))
  end

  it 'should default path to dir of views eql "./views"' do
    @srv.views.should eql(File.join(File.absolute_path("."), "views"))
  end
  
  it 'should default public folder of views eql "./public"' do
    @srv.static_folder.should eql(File.join(File.absolute_path("."), "public"))
  end

  def test_server(srv, opts)
    Rack::Server.should_receive(:start).with(opts).and_return(nil)
    srv.run!
  end
end
