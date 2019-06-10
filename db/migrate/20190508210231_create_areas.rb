class CreateAreas < ActiveRecord::Migration[5.2]
  def change
    create_table :areas do |t|
      t.string :area
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
