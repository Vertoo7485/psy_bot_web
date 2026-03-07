class CreateGardenElementTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :garden_element_templates do |t|
      t.string :name
      t.string :element_type
      t.string :icon
      t.string :color
      t.string :achievement
      t.jsonb :default_position

      t.timestamps
    end
  end
end
