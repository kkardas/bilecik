json.extract! user, :id, :name, :password, :money, :birth, :created_at, :updated_at
json.url user_url(user, format: :json)
