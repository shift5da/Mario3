# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170903011036) do

  create_table "device_smartpipes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "no"
    t.bigint "tunnel_1_id"
    t.bigint "tunnel_2_id"
    t.bigint "tunnel_3_id"
    t.bigint "tunnel_4_id"
    t.string "remark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tunnel_1_id"], name: "index_device_smartpipes_on_tunnel_1_id"
    t.index ["tunnel_2_id"], name: "index_device_smartpipes_on_tunnel_2_id"
    t.index ["tunnel_3_id"], name: "index_device_smartpipes_on_tunnel_3_id"
    t.index ["tunnel_4_id"], name: "index_device_smartpipes_on_tunnel_4_id"
  end

  create_table "engine_rules", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.bigint "pipeline_id"
    t.integer "timescope"
    t.integer "count"
    t.integer "priority"
    t.integer "start_position"
    t.integer "end_position"
    t.integer "occured_count"
    t.datetime "first_occur_at"
    t.boolean "is_active"
    t.datetime "valid_at"
    t.string "remark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pipeline_id"], name: "index_engine_rules_on_pipeline_id"
  end

  create_table "events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "device_id"
    t.integer "tunnel"
    t.bigint "pipeline_id"
    t.bigint "rule_id"
    t.integer "position"
    t.integer "category"
    t.integer "intensity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_events_on_device_id"
    t.index ["pipeline_id"], name: "index_events_on_pipeline_id"
    t.index ["rule_id"], name: "index_events_on_rule_id"
    t.index ["tunnel"], name: "index_events_on_tunnel"
  end

  create_table "incidents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "device_id"
    t.integer "tunnel"
    t.bigint "pipeline_id"
    t.bigint "rule_id"
    t.integer "position"
    t.integer "category"
    t.integer "intensity"
    t.string "related_events"
    t.boolean "is_handled"
    t.boolean "is_viewed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_incidents_on_device_id"
    t.index ["pipeline_id"], name: "index_incidents_on_pipeline_id"
    t.index ["rule_id"], name: "index_incidents_on_rule_id"
    t.index ["tunnel"], name: "index_incidents_on_tunnel"
  end

  create_table "pipe_line", id: :string, limit: 64, default: "", comment: "主键", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "管道线路" do |t|
    t.string "create_by", limit: 64, comment: "创建者"
    t.datetime "create_date", comment: "创建时间"
    t.string "update_by", limit: 64, comment: "更新者"
    t.datetime "update_date", comment: "更新时间"
    t.string "del_flag", limit: 64, comment: "逻辑删除标记（0：显示；1：隐藏）"
    t.string "name", limit: 200, comment: "线路名称"
    t.string "no", limit: 64, comment: "线路编号"
    t.string "start_position", limit: 200, comment: "开始位置"
    t.string "end_position", limit: 200, comment: "结束位置"
    t.string "area_id", limit: 64, comment: "归属区域"
    t.string "status", limit: 64, comment: "线路是否监控（0：是；1：否）"
    t.string "remarks", comment: "备注信息"
  end

  create_table "pipe_line_node", id: :string, limit: 64, default: "", comment: "主键", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "线路特征点" do |t|
    t.string "pipe_line_id", limit: 64, comment: "光缆线路"
    t.string "no", limit: 100, comment: "编号"
    t.float "lon", limit: 53, comment: "经度"
    t.float "lat", limit: 53, comment: "纬度"
    t.integer "gyjl", default: 0, comment: "光源距离"
    t.integer "dish", default: 0, comment: "盘纤距离"
    t.string "type1", limit: 64, default: "0", comment: "类型（0：井；1：辅助点）"
    t.string "remarks", comment: "备注信息"
    t.string "del_flag", limit: 64, comment: "逻辑删除标记（0：显示；1：隐藏）"
    t.string "create_by", limit: 64, comment: "创建者"
    t.datetime "create_date", comment: "创建时间"
    t.string "update_by", limit: 64, comment: "更新者"
    t.datetime "update_date", comment: "更新时间"
    t.integer "sort", comment: "排序"
  end

  create_table "pipeline_nodes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "pipeline_id"
    t.string "name"
    t.string "no"
    t.string "lng"
    t.string "lat"
    t.integer "distance"
    t.string "remark"
    t.integer "seq"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pipeline_id"], name: "index_pipeline_nodes_on_pipeline_id"
  end

  create_table "pipelines", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "no"
    t.string "start_position"
    t.string "end_position"
    t.string "remark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "account"
    t.string "password"
    t.datetime "first_login_at"
    t.datetime "last_login_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
