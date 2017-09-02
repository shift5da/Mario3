class CreatePipelines < ActiveRecord::Migration[5.1]
  def change
    create_table :pipelines do |t|
      t.string :name
      t.string :no
      t.string :start_position
      t.string :end_position
      t.string :remark

      t.timestamps
    end
  end
end
