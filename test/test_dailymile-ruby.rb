require 'helper'

class TestDailymileRuby < Test::Unit::TestCase
  def setup
  	WebMock.disable_net_connect!
  	

  end
  
  should "be able to post a simple entry" do
    # Stub setup
    params = { 
      :message => "Totally awesome", 
      :oauth_token    => "XXVTcIrfN2cIs43Yg3de56LIYGsWjTXmNiRmR6H4",
      :completed_at   => "2011-07-19 13:00"
    }

    stub_request(:post, "https://api.dailymile.com/entries.json").
      with(
        :body => Rack::Utils.build_nested_query( params ), 
        :headers => {'Accept'=>'application/json', 'Authorization'=>'OAuth XXVTcIrfN2cIs43Yg3de56LIYGsWjTXmNiRmR6H4', 
          'Content-Type'=>'application/x-www-form-urlencoded', 
          'User-Agent'=>'dailymile-ruby/0.2.0'}
        #:headers => { 'Authorization'=>'OAuth XXVTcIrfN2cIs43Yg3de56LIYGsWjTXmNiRmR6H4' }
      ).
      to_return(:status => 200, :body => "", :headers => {}
    )


    # Test
    Dailymile::Client.set_client_credentials 'qnFYExIvAhpsBLY4DU7w4jJerrmtBTUOQ4zccS1e', 'uE2tbUVPAjzXftUVZySLGvISEQkyeGQrSuh3Jz1n'
    client = Dailymile::Client.new 'XXVTcIrfN2cIs43Yg3de56LIYGsWjTXmNiRmR6H4'

    entry = Dailymile::Entry.new :message => "Totally awesome"
    client.post_entry(entry.entry)  
  end

  should "be able to post a complete entry" do
    # Stub setup
    params = { :message => "Totally awesome", 
      :workout => {
        :activity_type  => "running",
        :duration       => 3600,
        :felt           => "great",
        :calories       => 400,
        :title          => "API Test",
        :distance       => {
          :value => 5,
          :units => "kilometers"
        },
        :oauth_token    => "XXVTcIrfN2cIs43Yg3de56LIYGsWjTXmNiRmR6H4",
        :completed_at   => "2011-07-19 13:00"
      } 
    }

    stub_request(:post, "https://api.dailymile.com/entries.json").
      with(
        :body => Rack::Utils.build_nested_query( params ), 
        :headers => {'Accept'=>'application/json', 'Authorization'=>'OAuth XXVTcIrfN2cIs43Yg3de56LIYGsWjTXmNiRmR6H4', 
          'Content-Type'=>'application/x-www-form-urlencoded', 
          'User-Agent'=>'dailymile-ruby/0.2.0'}
   
        #:headers => { 'Authorization'=>'OAuth XXVTcIrfN2cIs43Yg3de56LIYGsWjTXmNiRmR6H4' }
      ).
      to_return(:status => 200, :body => "", :headers => {}
    )

    # Test
  	Dailymile::Client.set_client_credentials 'qnFYExIvAhpsBLY4DU7w4jJerrmtBTUOQ4zccS1e', 'uE2tbUVPAjzXftUVZySLGvISEQkyeGQrSuh3Jz1n'
  	client = Dailymile::Client.new 'XXVTcIrfN2cIs43Yg3de56LIYGsWjTXmNiRmR6H4'

  	entry = Dailymile::Entry.new :message => "Totally awesome"
  	entry.activity_type = "running" 
  	entry.duration=3600
  	entry.felt="great"
  	entry.calories=400
  	entry.title="API Test"
    entry.completed_at=DateTime.parse('2011-07-19 13:00')

  	# Test units optional
  	distance = { "value" => 5, "units" => "kilometers" }
  	entry.distance=distance

  	client.post_entry(entry.entry)  
  end
  
  should "probably rename this file and start testing for real" do
    flunk "hey buddy, you should probably rename this file and start testing for real"
  end
end
