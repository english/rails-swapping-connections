Rails.application.routes.draw do
  match "/", to: proc {
    object_id = ActiveRecord::Base.connection.object_id
    connection_id = ActiveRecord::Base.connection_id
    [200, {}, ["object_id: #{object_id}, connection_id: #{connection_id}"]]
  }, via: :get
end
