# frozen_string_literal: false

require 'sequel'

Sequel.migration do
  change do
    create_table(:routes) do
      primary_key :id
      String      :uid
      String      :name_zh
      String      :name_en
      String      :depart_name_zh
      String      :depart_name_eh
      String      :destination_name_zh
      String      :destination_name_en
      String      :auth_id

      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end