class ChangeScoreToJsonbInTestResults < ActiveRecord::Migration[7.1]
  def change
    remove_column :test_results, :score, :integer
    add_column :test_results, :score, :jsonb, default: {}
  end
end