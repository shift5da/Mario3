class CreateDeviceSmartpipe < ActiveRecord::Migration[5.1]
  def change
    create_table :device_smartpipes do |t|
      t.string :name
      t.integer :no
      t.references :tunnel_1, index: true
      t.references :tunnel_2, index: true
      t.references :tunnel_3, index: true
      t.references :tunnel_4, index: true

      t.string :remark

      t.timestamps
    end
  end
end
