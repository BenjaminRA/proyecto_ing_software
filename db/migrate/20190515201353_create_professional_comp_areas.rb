class CreateProfessionalCompAreas < ActiveRecord::Migration[5.2]
  def change
    create_table :professional_comp_areas do |t|
      t.string :area
      t.references :professional_comp_cat, foreign_key: true

      t.timestamps
    end
  end
end
