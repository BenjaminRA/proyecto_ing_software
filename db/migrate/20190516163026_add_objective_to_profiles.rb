class AddObjectiveToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :objective, :text
  end
end
