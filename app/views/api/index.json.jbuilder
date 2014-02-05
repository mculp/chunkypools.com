json.array!(@apis) do |api|
  json.extract! api, :id
  json.url api_url(api, format: :json)
end
