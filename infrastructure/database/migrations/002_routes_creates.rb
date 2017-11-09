# frozen_string_literal: false

require 'sequel'

Sequel.migration do
  change do
    create_table(:routes) do
<<<<<<< HEAD:infrastructure/database/migrations/002_bus_routes_create.rb
     # primary_key :id
      String      :id, primary_key: true
      String      :name_zh
      String      :name_en
      String      :depart_name_zh
      String      :depart_name_en
      String      :destination_name_zh
      String      :destination_name_en
=======
      String      :id, primary_key: true
      String      :name_zh
      String      :name_en
      String      :dep_zh
      String      :dep_en
      String      :dest_zh
      String      :dest_en
>>>>>>> 41cc67b96fc41aaee83676ae2e28b8ed1f470d40:infrastructure/database/migrations/002_routes_creates.rb
      Integer     :auth_id

      DateTime    :created_at
      DateTime    :updated_at

     
    end
  end
end
