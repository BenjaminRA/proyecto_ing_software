class CreateProfileAbilities < ActiveRecord::Migration[5.2]
  def change
    create_table :profile_abilities do |t|
      t.references :profile, foreign_key: true
      t.references :ability, foreign_key: true
      t.integer :value

      t.timestamps
    end
  end
end
