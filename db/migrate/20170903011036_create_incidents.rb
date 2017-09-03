class CreateIncidents < ActiveRecord::Migration[5.1]
  def change
    create_table :incidents do |t|

      t.references :device, index: true
      t.integer :tunnel, index: true
      t.references :pipeline, index: true
      t.references :rule, index: true
      t.integer :position     #告警位置
      t.integer :category     #告警类型
      t.integer :intensity     #强度
      t.string :related_events    #产生该incident所关联的events，采用"event_id:event_id:event_id"的方式进行分割
      t.boolean :is_handled   #是否被处理
      t.boolean :is_viewed    #是否被查看

      t.timestamps
    end
  end
end
