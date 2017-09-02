class CreatePipelineNodes < ActiveRecord::Migration[5.1]
  def change
    create_table :pipeline_nodes do |t|

      t.references :pipeline, index: true
      t.string :name
      t.string :no
      t.string :lng
      t.string :lat
      t.integer :distance
      t.string :remark
      t.integer :seq

      t.timestamps
    end
  end
end
