json.array!(@caves) do |cafe|
  json.extract! cafe, :id, :name, :lat, :lon, :url, :address
  json.url cafe_url(cafe, format: :json)
end
