json.extract! group, :id, :name, :description, :created_at, :updated_at, :start_hour, :end_hour, :color
json.url group_url(group, format: :json)
