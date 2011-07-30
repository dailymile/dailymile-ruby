require 'helper'

class TestDailymileRuby < Test::Unit::TestCase
  def setup
  	WebMock.disable_net_connect!
  	
  	params = { :message => 'Totally awesome', 
  		:workout => {
  		  :activity_type 	=> 'running',
  		  :duration 			=> 3600,
  		  :felt 					=> 'great',
  		  :calories 			=> 400,
  		  :title 					=> 'API Test',
  		  :distance				=> {
  		    :value => 5,
  		    :units => 'kilometers'
  		  },
  		  :oauth_token		=> 'XXVTcIrfN2cIs43Yg3de56LIYGsWjTXmNiRmR6H4',
  		  :completed_at		=> '2011-07-19 13:00'
  		}	
  	}
		
		stub_request(:post, "https://api.dailymile.com/entries.json").
			with(:body => Rack::Utils.build_nested_query( params ), 
				   :headers => { 'Authorization'=>'OAuth XXVTcIrfN2cIs43Yg3de56LIYGsWjTXmNiRmR6H4' }
			).
			to_return(:status => 200, :body => "", :headers => {})
		
		
  	
  end
  
  should "be able to post an entry" do
		Dailymile::Client.set_client_credentials 'qnFYExIvAhpsBLY4DU7w4jJerrmtBTUOQ4zccS1e', 'uE2tbUVPAjzXftUVZySLGvISEQkyeGQrSuh3Jz1n'
		client = Dailymile::Client.new 'XXVTcIrfN2cIs43Yg3de56LIYGsWjTXmNiRmR6H4'


		entry = Dailymile::Entry.new :message => "Totally awesome"


		entry.activity_type = "running" 
		entry.duration=3600
		entry.felt="great"
		entry.calories=400
		entry.title="API Test"

		# Test units optional
		distance = { "value" => 5, "units" => "kilometers" }
		entry.distance=distance

		#entry.completed_at=""
		entry.completed_at=DateTime.parse('2011-07-19 13:00')

		puts entry.entry

		client.post_entry(entry.entry)  
		
		
  end
  
  should "probably rename this file and start testing for real" do
    flunk "hey buddy, you should probably rename this file and start testing for real"
  end
end
