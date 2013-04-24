class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer :Unixtime
      t.string :LogionID
      t.string :Destip

      t.timestamps
    end
  end
end
