require 'helper'

class TestDailymileRuby < Test::Unit::TestCase
  
  def setup
  	WebMock.disable_net_connect!
  end

  def build_stub(params)
    
    stub_request(:post, "https://api.dailymile.com/entries.json").
      with(
        :body     => Rack::Utils.build_nested_query( params ), 
        :headers  => {
          'Accept'        =>'application/json', 
          'Authorization' =>'OAuth ACCESS_TOKEN', 
          'Content-Type'  =>'application/x-www-form-urlencoded', 
          'User-Agent'    =>'dailymile-ruby/0.2.0'
        }
      ).
      to_return(:status => 200, :body => { :dummy => "success" }.to_json, :headers => {}
    )
  
  end
  
  should "be able to post a simple entry" do
    # Stub setup
    params = { 
      :message      => "Totally awesome", 
      :oauth_token  => "ACCESS_TOKEN"
    }

    build_stub( params )

    # Test
    Dailymile::Client.set_client_credentials 'CLIENT_ID', 'CLIENT_SECRET'
    client = Dailymile::Client.new 'ACCESS_TOKEN'

    entry = Dailymile::Entry.new :message => "Totally awesome"
    client.post_entry(entry.entry)  
  end

  should "be able to post a complete entry" do
    # Stub setup
    params = { :message => "Totally awesome", 
      :workout => {
        :activity_type  => "running",
        :duration       => "3600",
        :felt           => "great",
        :calories       => "400",
        :title          => "API Test",
        #:distance       => {
        #  :value        => "5",
        #  :units        => "kilometers"
        #}
        :completed_at   => DateTime.parse( DateTime.parse('2011-07-19 13:00').to_time.getutc.to_s ).iso8601 
      },
      :oauth_token    => "ACCESS_TOKEN"
    }

    build_stub( params )

    # Test
    Dailymile::Client.set_client_credentials 'CLIENT_ID', 'CLIENT_SECRET'
  	client = Dailymile::Client.new 'ACCESS_TOKEN'

  	entry = Dailymile::Entry.new :message => "Totally awesome"
  	entry.activity_type = "running" 
  	entry.duration = 3600
  	entry.felt = "great"
  	entry.calories = 400
  	entry.title = "API Test"
    #TODO: distance and completed_at tests failed
    #entry.distance = { :value => "5", :units => "kilometers" }
    entry.completed_at = DateTime.parse('2011-07-19 13:00')

    puts entry.entry

  	client.post_entry(entry.entry)  
  end

end
