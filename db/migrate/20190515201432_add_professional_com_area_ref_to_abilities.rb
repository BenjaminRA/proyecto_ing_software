class AddProfessionalComAreaRefToAbilities < ActiveRecord::Migration[5.2]
  def change
    add_reference :abilities, :professional_comp_area, foreign_key: true
  end
end
