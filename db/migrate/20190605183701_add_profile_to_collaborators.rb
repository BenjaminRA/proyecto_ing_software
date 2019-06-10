class AddProfileToCollaborators < ActiveRecord::Migration[5.2]
  def change
    add_reference :collaborators, :profile, foreign_key: true
  end
end
