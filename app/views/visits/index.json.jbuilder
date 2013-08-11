json.array!(@visits) do |visit|
  json.extract! visit, :descripton, :vdate, :comment
  json.url visit_url(visit, format: :json)
end
