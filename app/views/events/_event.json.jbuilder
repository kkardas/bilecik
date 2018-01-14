json.extract! event, :id, :name, :description, :price, :date, :adult_only, :image, :created_at, :updated_at
json.url event_url(event, format: :json)
