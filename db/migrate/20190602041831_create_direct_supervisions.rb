class CreateDirectSupervisions < ActiveRecord::Migration[5.2]
  def change
    create_table :direct_supervisions do |t|
      t.references :from, foreign_key: {:to_table => :profiles}
      t.references :to, foreign_key: {:to_table => :profiles}

      t.timestamps
    end
  end
end
