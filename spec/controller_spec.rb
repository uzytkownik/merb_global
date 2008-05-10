require File.join(File.dirname(__FILE__), 'spec_helper.rb')

class TestController < Merb::Controller
  def index
    "index"
  end
end

describe Merb::Controller do
  it "should set language to english by default" do
    controller = dispatch_to(TestController, :index) do |controller|
      controller.request.env.delete 'HTTP_ACCEPT_LANGUAGE'
    end
    controller.lang.should == 'en'
  end
  it "should set language according to the preferences" do
    controller = dispatch_to(TestController, :index) do |controller|
      controller.request.env['HTTP_ACCEPT_LANGUAGE'] = 'fr'
      controller.provider = provider = stub(:supported? => true)
    end
    controller.lang.should == 'fr'
  end
  it "should take the weights into account" do
    controller = dispatch_to(TestController, :index) do |controller|
      controller.request.env['HTTP_ACCEPT_LANGUAGE'] =
        'de;q=0.8,en;q=1.0,es;q=0.6'
      controller.provider = mock "provider" do |provider|
        provider.expects(:supported?).with("de").returns(true)
        provider.expects(:supported?).with("en").returns(false)
        provider.stubs(:supported?).with("es").returns(true)
      end
    end
    controller.lang.should == 'de'
  end
  it "should assume 1.0 as default weight" do
    controller = dispatch_to(TestController, :index) do |controller|
      controller.request.env['HTTP_ACCEPT_LANGUAGE'] = 'it,en;q=0.7'
      provider = controller.provider = stub(:supported? => true)
    end
    controller.lang.should == 'it'
  end
end

