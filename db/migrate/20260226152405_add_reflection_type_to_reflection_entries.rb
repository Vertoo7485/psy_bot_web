class AddReflectionTypeToReflectionEntries < ActiveRecord::Migration[7.1]
  def change
    add_column :reflection_entries, :reflection_type, :string
  end
end
