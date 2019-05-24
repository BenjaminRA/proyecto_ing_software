class CreateProfessionalCompCats < ActiveRecord::Migration[5.2]
  def change
    create_table :professional_comp_cats do |t|
      t.string :category

      t.timestamps
    end
  end
end
