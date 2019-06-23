class CreatePeriods < ActiveRecord::Migration[5.2]
  def change
    create_table :periods do |t|
      t.date :start_date
      t.date :finish_date

      t.timestamps
    end
  end
end
