module Dailymile

  class Entry

		#message, string (optional)
		#lat, float (optional) the latitude of this entry, between -90 and 90
		#lon, float (optional) the longitude of this entry, between -180 and 180
		#Include if posting a workout:
		#workout[activity_type], string
		#workout[completed_at], datetime (optional)
		#workout[distance][value], float (optional)
		#workout[distance][units], string (optional)
		#workout[duration], integer (optional)
		#workout[felt], string (optional)
		#workout[calories], integer (optional)
		#workout[title], string (optional)
		#workout[route_id], integer (optional)

		#{"message"=>"I am running", "activity_type"=>"running", "distance"=>{"value"=>"5", "units"=>"km"}}


		attr_reader :message, :lat, :lon
		attr_writer :message, :lat, :lon

		ACTIVITY_TYPES 	= [ "running", "cycling", "swimming", "walking", "fitness" ]
		DISTANCE_UNITS 	= [ "miles", "kilometers", "yards", "meters" ]
		FEELINGS 				= [ "great", "good", "alright", "blah", "tired", "injured"] 

		def initialize(message=nil)
			@entry={}
			@entry['workout']={}
			@entry['message']=message
		end

		def activity_type=(activity_type)
			unless ACTIVITY_TYPES.include?( activity_type )
				#TODO raise a proper exception
				raise 'WorkoutException: unknown activity type ' + activity_type
			else
				@entry['workout'][ 'activity_type' ] = activity_type
			end 
		end

		#workout[completed_at], datetime (optional) when the workout was done, formatted in ISO 8601 and in UTC. ex: 2011-01-11T03:54:43Z
		# TODO: workout how date and time works in ruby 
		def completed_at=(year,month,date,hour=0,min=0,sec=0)
			# this looks awfully wrong 
			@entry['workout'][ 'completed_at' ] = year+'-'+month+'-'+date+'T'+hour+':'+min+':'+sec+'Z' 
		end

		#workout[distance][value], float (optional)  the distance indicated by units
		#TODO: cannot workout how to do distance=
		def set_distance(value,units=nil)
			@entry['workout'][ 'distance' ]={}
			@entry['workout'][ 'distance' ][ 'value' ] = value
			unless units.nil?
				unless DISTANCE_UNITS.include?( units )
					#TODO raise a proper exception
					raise 'WorkoutException: unknown units ' + units
				else			
					@entry['workout'][ 'distance' ][ 'units' ] = units
				end 
			end
		end
				
		def duration=(duration)
			@entry['workout'][ 'duration' ] = duration
		end
		
		def felt=(felt)
			unless FEELINGS.include?( felt )
				#TODO raise a proper exception
				raise 'WorkoutException: unknown feeling ' + felt
			else
				@entry['workout'][ 'felt' ] = felt
			end
		end
		
		def calories=(calories)
			@entry['workout'][ 'calories' ] = felt
		end
		
		def title=(title)
			@entry['workout'][ 'title' ] = title
		end
		
		def route_id=(route_id)
			@entry['workout'][ 'route_id' ] = route_id
		end
		
		def get_entry
		 
		end
		
		def message=(message)
			@entry[ 'message' ] = message
		end

		def workout
			@entry['workout']
		end 
		
		def entry
			@entry
		end   
  end
end
