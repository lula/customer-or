json.array!(@organizations) do |organization|
  json.extract! organization, :name, :country
  json.url organization_url(organization, format: :json)
end
