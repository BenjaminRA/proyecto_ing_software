class AddFunctionsToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :functions, :text
  end
end
