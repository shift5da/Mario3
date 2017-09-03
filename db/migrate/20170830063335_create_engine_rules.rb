class CreateEngineRules < ActiveRecord::Migration[5.1]
  def change
    create_table :engine_rules do |t|
      t.string :name
      t.references :pipeline, index: true

      t.integer :timescope      #时间窗口，单位秒
      t.integer :count    #在时间窗口内，发生的次数
      t.integer :priority   #优先级，数字越大，优先级越高
      t.integer :start_position  #起始位置，单位米
      t.integer :end_position     #结束位置，单位米
      t.integer :occured_count    #在时间窗口内，已经发生的次数
      t.datetime :first_occur_at   #第一次发生的时间

      t.boolean :is_active      # boolean 是否有效
      t.datetime :valid_at      #有效时间

      t.string :remark

      t.timestamps
    end
  end
end
