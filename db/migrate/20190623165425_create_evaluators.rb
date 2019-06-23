class CreateEvaluators < ActiveRecord::Migration[5.2]
  def change
    create_table :evaluators do |t|
      t.references :collaborator, foreign_key: true
      t.references :period, foreign_key: true

      t.timestamps
    end
  end
end
