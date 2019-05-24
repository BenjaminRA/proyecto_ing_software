class CreateReportsTos < ActiveRecord::Migration[5.2]
  def change
    create_table :reports_tos do |t|
      t.references :sender, foreign_key: {to_table: :profiles}
      t.references :reciever, foreign_key: {to_table: :profiles}

      t.timestamps
    end

  end
end
