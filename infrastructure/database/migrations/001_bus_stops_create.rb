# frozen_string_literal: false

require 'sequel'

# so happy today
Sequel.migration do
  change do
    create_table(:stops) do
      primary_key :id
      String      :uid
      String      :name_zh
      String      :name_en
      Float       :lat
      Float       :lon
      String      :auth_id
      String      :address

      DateTime :created_at
      DateTime :updated_at
    end
  end
end