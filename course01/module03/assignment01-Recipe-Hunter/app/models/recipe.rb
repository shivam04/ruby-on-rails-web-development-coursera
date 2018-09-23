class Recipe
	include HTTParty
	
	key_value = ENV['FOOD2FORK_KEY'] || "c01b841ba3c096dafd59675944c2e01b"
	hostport = ENV['FOOD2FORK_SERVER_AND_PORT'] || 'food2fork.com'
	base_uri "http://food2fork.com/api"
	#base_uri "http://#{hostport}/api"
	default_params key: key_value 
	format :json

	def self.for term
		get("/search", query: {q: term})["recipes"]
	end
end

