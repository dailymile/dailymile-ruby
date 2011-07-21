module Dailymile

  class Entry

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

		# TODO: Need to do datevtype checking here
		def completed_at=(datetime)
			@entry['workout'][ 'completed_at' ] = DateTime.parse( datetime.to_time.getutc.to_s ).iso8601
		end

		#TODO: how to type check that distance is hash?
		def distance=(distance)
			@entry['workout'][ 'distance' ]={}
			@entry['workout'][ 'distance' ][ 'value' ] = distance[ 'value' ]
			unless distance[ 'units' ].nil?
				unless DISTANCE_UNITS.include?( distance['units'] )
					#TODO raise a proper exception
					raise 'WorkoutException: unknown units ' + distance['units']
				else			
					@entry['workout'][ 'distance' ][ 'units' ] = distance['units']
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
			@entry['workout'][ 'calories' ] = calories
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
