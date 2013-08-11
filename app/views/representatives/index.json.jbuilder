json.array!(@representatives) do |representative|
  json.extract! representative, :name
  json.url representative_url(representative, format: :json)
end
