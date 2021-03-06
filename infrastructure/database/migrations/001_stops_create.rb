# frozen_string_literal: false

require 'sequel'

Sequel.migration do
  change do
    create_table(:stops) do
      String :id, primary_key: true
      String    	:name_zh
      String    	:name_en
      String    	:address
      Float     	:latitude
      Float       :longitude
      String      :city_name
      String      :auth_id

      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
