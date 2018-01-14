json.extract! ticket, :id, :price, :event_id, :user_id, :created_at, :updated_at
json.url ticket_url(ticket, format: :json)
