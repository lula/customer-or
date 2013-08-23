json.array!(@visits) do |visit|
  json.extract! visit, :description, :vdate, :comment
  json.url visit_url(visit, format: :json)
end
