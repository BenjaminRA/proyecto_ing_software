class CreateReplaceBies < ActiveRecord::Migration[5.2]
  def change
    create_table :replace_bies do |t|
      t.references :to_replace, foreign_key: {:to_table => :profiles}
      t.references :replacement, foreign_key: {to_table: :profiles}

      t.timestamps
    end
  end
end
