require 'helper'

class TestDailymileRuby < Test::Unit::TestCase
  def setup
    WebMock.disable_net_connect!
  end
  
  should "be able to post a simple entry" do
    # Stub setup
    params = { 
      :message      => "Totally awesome", 
      :oauth_token  => "XXVTcIrfN2cIs43Yg3de56LIYGsWjTXmNiRmR6H4"
    }

    stub_request(:post, "https://api.dailymile.com/entries.json").
      with(
        :body => Rack::Utils.build_nested_query( params ), 
        :headers => {
          'Accept'=>'application/json', 
          'Authorization'=>'OAuth XXVTcIrfN2cIs43Yg3de56LIYGsWjTXmNiRmR6H4', 
          'Content-Type'=>'application/x-www-form-urlencoded', 
          'User-Agent'=>'dailymile-ruby/0.2.0'}
      ).
      to_return(:status => 200, :body => {'success'=>'true'}.to_json, :headers => {}
    )

    # Test
    Dailymile::Client.set_client_credentials 'qnFYExIvAhpsBLY4DU7w4jJerrmtBTUOQ4zccS1e', 'uE2tbUVPAjzXftUVZySLGvISEQkyeGQrSuh3Jz1n'
    client = Dailymile::Client.new 'XXVTcIrfN2cIs43Yg3de56LIYGsWjTXmNiRmR6H4'

    entry = Dailymile::Entry.new :message => "Totally awesome"
    client.post_entry(entry.entry)  
  end
  
end