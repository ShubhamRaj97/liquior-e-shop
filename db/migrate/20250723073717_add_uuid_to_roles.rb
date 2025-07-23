class AddUuidToRoles < ActiveRecord::Migration[7.2]
  def change
    add_column :roles, :uuid, :uuid, default: -> { "uuid_generate_v4()" }, null: false
  end
end
