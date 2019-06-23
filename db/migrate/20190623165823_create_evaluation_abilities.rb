class CreateEvaluationAbilities < ActiveRecord::Migration[5.2]
  def change
    create_table :evaluation_abilities do |t|
      t.references :ability, foreign_key: true
      t.references :evaluation, foreign_key: true
      t.integer :value

      t.timestamps
    end
  end
end
