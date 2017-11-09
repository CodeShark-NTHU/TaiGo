# frozen_string_literal: false

require 'sequel'

Sequel.migration do
  change do
    create_table(:routes) do
      String      :id, primary_key: true
      String      :name_zh
      String      :name_en
      String      :dep_zh
      String      :dep_en
      String      :dest_zh
      String      :dest_en
      Integer     :auth_id

      DateTime    :created_at
      DateTime    :updated_at

     
    end
  end
end
