class AddFieldsToGardenElement < ActiveRecord::Migration[7.1]
  def change
    add_column :garden_elements, :name, :string
    add_column :garden_elements, :icon, :string
    add_column :garden_elements, :color, :string
    add_column :garden_elements, :achievement, :string
    add_column :garden_elements, :default_position, :jsonb
  end
end
