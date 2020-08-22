# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_22_073142) do

  create_table "claims", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "service_id"
    t.integer "app_template_id"
    t.string "service_name"
    t.string "app_template_name"
    t.integer "status", limit: 1
    t.integer "priority", limit: 1
    t.integer "id_tn"
    t.integer "tn"
    t.string "fio"
    t.integer "dept"
    t.json "user_details"
    t.json "attributes"
    t.integer "rating", limit: 1
    t.datetime "finished_at_plan"
    t.datetime "finished_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dept"], name: "index_claims_on_dept"
    t.index ["fio"], name: "index_claims_on_fio"
    t.index ["id_tn"], name: "index_claims_on_id_tn"
    t.index ["priority"], name: "index_claims_on_priority"
    t.index ["status"], name: "index_claims_on_status"
    t.index ["tn"], name: "index_claims_on_tn"
  end

end
