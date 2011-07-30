module Dailymile

  class Entry

		attr_accessor :message, :lat, :lon

		ACTIVITY_TYPES 	= [ "running", "cycling", "swimming", "walking", "fitness" ]
		DISTANCE_UNITS 	= [ "miles", "kilometers", "yards", "meters" ]
		FEELINGS 				= [ "great", "good", "alright", "blah", "tired", "injured"] 

		def initialize(attributes={})
			@attributes = attributes
			@attributes['workout'] ||= {}
		end

		def activity_type=(activity_type)
			unless ACTIVITY_TYPES.include?( activity_type )
				raise DailymileError, 'WorkoutException: unknown activity type ' + activity_type
			else
				@attributes['workout'][ 'activity_type' ] = activity_type
			end 
		end

		# TODO: Need to do datevtype checking here
		def completed_at=(datetime)
			@attributes['workout'][ 'completed_at' ] = DateTime.parse( datetime.to_time.getutc.to_s ).iso8601
		end

		#TODO: how to type check that distance is hash?
		def distance=(distance)
			@attributes['workout'][ 'distance' ] ||= {}
			@attributes['workout'][ 'distance' ][ 'value' ] = distance[ 'value' ]
			if distance[ 'units' ]
				unless DISTANCE_UNITS.include?( distance['units'] )
					raise DailymileError, 'WorkoutException: unknown units ' + distance['units']
				else			
					@attributes['workout'][ 'distance' ][ 'units' ] = distance['units']
				end 
			end
		end
				
		def duration=(duration)
			@attributes['workout'][ 'duration' ] = duration
		end
		
		def felt=(felt)
			unless FEELINGS.include?( felt )
				#TODO raise a proper exception
				raise DailymileError, 'WorkoutException: unknown feeling ' + felt
			else
				@attributes['workout'][ 'felt' ] = felt
			end
		end
		
		def calories=(calories)
			@attributes['workout'][ 'calories' ] = calories
		end
		
		def title=(title)
			@attributes['workout'][ 'title' ] = title
		end
		
		def route_id=(route_id)
			@attributes['workout'][ 'route_id' ] = route_id
		end
		
		def message=(message)
			@attributes[ 'message' ] = message
		end

		def workout
			@attributes['workout']
		end 
		
		def entry
			@attributes
		end   
  end
end
