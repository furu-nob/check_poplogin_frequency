class CreateTempLogs < ActiveRecord::Migration
  def change
    create_table :temp_logs do |t|
      t.integer :Unixtime
      t.string :LogionID
      t.string :Destip

      t.timestamps
    end
  end
end
