class CreateAbilities < ActiveRecord::Migration[5.2]
  def change
    create_table :abilities do |t|
      t.string :ability
      t.references :abilities_type, foreign_key: true
      t.references :area, foreign_key: true

      t.timestamps
    end
  end
end
