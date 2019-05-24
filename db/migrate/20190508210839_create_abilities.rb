class CreateAbilities < ActiveRecord::Migration[5.2]
  def change
    create_table :abilities do |t|
      t.string :ability
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
