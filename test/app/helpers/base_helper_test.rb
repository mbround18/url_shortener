require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

describe "UrlShort::App::BaseHelper" do
  before do
    @helpers = Class.new
    @helpers.extend UrlShort::App::BaseHelper
  end

  def helpers
    @helpers
  end

  it "should return nil" do
    assert_nil helpers.foo
  end
end
