class CreateDeviceSmartPipes < ActiveRecord::Migration[5.1]
  def change
    create_table :device_smart_pipes do |t|
      t.string :name
      t.string :no      #设备编号
      t.string :remark
      t.timestamps
    end

    create_table :device_smart_pipe_tunnels do |t|
      t.references :device_smart_pipe, index: true
      t.integer :no       #通道编号
      t.string :remark
      t.timestamps
    end

  end
end
