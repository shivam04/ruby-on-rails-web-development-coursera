class Place
  include ActiveModel::Model
  attr_accessor :id, :formatted_address, :location, :address_components

  def self.mongo_client
  	Mongoid::Clients.default
  end

  def self.collection
  	db = mongo_client
  	db = db.use('places_development')
  	db[:places]
  end

  def self.load_all(f)
  	f = JSON.parse(f.read)
  	collection.insert_many(f)
  end

  def initialize(args)
    @id = args[:_id].nil? ? args[:id] : args[:_id].to_s
    @formatted_address = args[:formatted_address]
    @address_components = args[:address_components].nil? ? []
      : args[:address_components].map {|comp| AddressComponent.new(comp)}
    @location = Point.new(args[:geometry][:geolocation])
  end

  def self.find_by_short_name(short_name)
    collection.find('address_components.short_name' => short_name)
  end

  def self.to_places(places_collection)
    places_collection.map do |place|
      Place.new(place)
    end
  end

  def self.find(id)
    hash = collection.find(_id: BSON::ObjectId.from_string(id)).first
    Place.new(hash) unless hash.nil?
  end

  def self.all(offset = 0, limit = nil)
    result = collection.find.skip(offset)
    result = result.limit(limit) unless limit.nil?
    to_places(result)
  end

  def destroy
    self.class.collection.find(_id: BSON::ObjectId.from_string(@id)).delete_one
  end

  def self.get_address_components(sort = nil, offset = nil, limit = nil)
    aggregate = [
      {:$unwind => '$address_components'},
      {:$project => {:address_components => 1, :formatted_address => 1, :geometry => {:geolocation => 1}}}]
    aggregate << {:$sort => sort} unless sort.nil?
    aggregate << {:$skip => offset} unless offset.nil?
    aggregate << {:$limit => limit} unless limit.nil?
    collection.find.aggregate(aggregate)
  end

  def self.get_country_names
    collection.aggregate([
      {:$unwind => '$address_components'},
      {:$match => {'address_components.types' => 'country'}},
      {:$group => {_id: 0, country_names: {:$addToSet => '$address_components.long_name'}}}
      ]).first[:country_names]
  end

  def self.find_ids_by_country_code(country_code)
    collection.aggregate([
      {:$match => {'address_components.types' => 'country', 'address_components.short_name' => country_code}},
      {:$project => {_id: 1}}
      ]).map {|doc| doc[:_id].to_s}
  end

  def self.create_indexes
    collection.indexes.create_one(
      {'geometry.geolocation' => Mongo::Index::GEO2DSPHERE},
      {name: 'geometry.geolocation_2dsphere'})
  end

  def self.remove_indexes
    collection.indexes.drop_one 'geometry.geolocation_2dsphere'
  end

  def self.near(point, max_meters = nil)
    collection.find(
        'geometry.geolocation' => {:$near => {
            :$geometry => point.to_hash,
            :$maxDistance => max_meters
          }}
      )
  end

  def near(max_meters = nil)
    self.class.to_places(self.class.near(@location, max_meters))
  end

  def photos(offset = 0, limit = nil)
    result = Photo.find_photos_for_place(@id).skip(offset)
    result = result.limit(limit) unless limit.nil?
    result.map {|doc| Photo.new(doc)}
  end

  def persisted?
    !@id.nil? 
  end
end
