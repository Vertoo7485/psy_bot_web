class CreateReflectionAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :reflection_answers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :day, null: false, foreign_key: true
      t.string :question_key
      t.text :answer

      t.timestamps
    end
  end
end
