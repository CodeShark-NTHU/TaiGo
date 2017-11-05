# frozen_string_literal: false

require 'sequel'

Sequel.migration do
  change do
    create_table(:routes) do
      primary_key :id
      String      :uid
      String      :name_zh
      String      :name_en
      String      :depart_name
      String      :destination_name
      String      :auth_id

      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end