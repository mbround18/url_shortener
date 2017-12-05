require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "Url Model" do
  it 'can construct a new instance' do
    @url = Url.new
    refute_nil @url
  end
end
