class AddProfileToEvaluations < ActiveRecord::Migration[5.2]
  def change
    add_reference :evaluations, :profile, foreign_key: true
  end
end
