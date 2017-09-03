class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|

      t.references :device, index: true
      t.integer :tunnel, index: true
      t.references :pipeline, index: true
      t.references :rule, index: true
      t.integer :position     #告警位置
      t.integer :category     #告警类型
      t.integer :intensity     #强度

      t.timestamps
    end
  end
end
