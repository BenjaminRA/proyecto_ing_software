class CreateEvaluations < ActiveRecord::Migration[5.2]
  def change
    create_table :evaluations do |t|
      t.references :collaborator, foreign_key: true
      t.references :evaluator, foreign_key: true

      t.timestamps
    end
  end
end
