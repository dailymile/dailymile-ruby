module Dailymile

  class Workout

		ACTIVITY_TYPES 	= [ "running", "cycling", "swimming", "walking", "fitness" ]
		DISTANCE_UNITS 	= [ "miles", "kilometers", "yards", "meters" ]
		FEELINGS 				= [ "great", "good", "alright", "blah", "tired", "injured"] 

		def initialize
			@workout = Hash.new
		end

		def set_activity_type( activity_type )
			unless ACTIVITY_TYPES.include?( activity_type )
				raise 'WorkoutException: unknown activity type ' + activity_type
			else
				@workout[ 'activity_type' ] = activity_type
			end 
		end

		#workout[completed_at], datetime (optional) when the workout was done, formatted in ISO 8601 and in UTC. ex: 2011-01-11T03:54:43Z
		# TODO: workout how date and time works in ruby 
		def set_completed_at( year, month, date, hour = 0, min = 0, sec = 0 )
			# this looks awfully wrong 
			@workout[ 'completed_at' ] = year+'-'+month+'-'+date+'T'+hour+':'+min+':'+sec+'Z' 
		end

		#workout[distance][value], float (optional)  the distance indicated by units
		def set_distance( value, units = nil )
			@workout[ 'distance' ] = Hash.new
			@workout[ 'distance' ][ 'value' ] = value
			unless units.nil?
				@workout[ 'distance' ][ 'units' ] = units 
			end
		end
				
		def set_duration
		end
		
		def set_felt 
		end
		
		def set_calories 
		end
		
		def set_title 
		end
		
		def set_route_id 
		end

		#Include if posting a workout:
		#workout[duration], integer (optional)
		#workout[calories], integer (optional)the number of calories burned during the workout
		#workout[title], string (optional) optional title for a workout
		#workout[route_id], integer (optional) the id of the route associated with this workout (see route docs)   
		#workout[duration], integer (optional)
		#workout[felt], string (optional) "great", "good", "alright", "blah", "tired" or "injured"
		#workout[calories], integer (optional)the number of calories burned during the workout
		#workout[title], string (optional) optional title for a workout
		#workout[route_id], integer (optional) the id of the route associated with this workout (see route docs)   
				
		def get_workout
			@workout
		end
		      
  end
end
