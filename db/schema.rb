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

ActiveRecord::Schema.define(version: 2020_08_24_021458) do

  create_table "acls", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", limit: 45
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_acls_on_name"
  end

  create_table "claims", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
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
    t.json "attrs"
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

  create_table "group_acls", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "group_id", null: false
    t.bigint "acl_id", null: false
    t.boolean "value", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["acl_id"], name: "index_group_acls_on_acl_id"
    t.index ["group_id"], name: "index_group_acls_on_group_id"
    t.index ["role_id"], name: "index_group_acls_on_role_id"
  end

  create_table "groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", limit: 45
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_groups_on_name"
  end

  create_table "roles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", limit: 45
    t.string "description"
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "group_id", null: false
    t.integer "tn", null: false
    t.integer "id_tn", null: false
    t.string "fio", null: false
    t.string "work_tel", limit: 45
    t.string "mobile_tel", limit: 45
    t.string "email", limit: 45
    t.boolean "is_vacation", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["fio"], name: "index_users_on_fio"
    t.index ["group_id"], name: "index_users_on_group_id"
    t.index ["id_tn"], name: "index_users_on_id_tn"
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["tn"], name: "index_users_on_tn"
  end

  create_table "works", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "claim_id", null: false
    t.string "title", limit: 45
    t.integer "status", limit: 1
    t.json "attrs"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["claim_id"], name: "index_works_on_claim_id"
    t.index ["status"], name: "index_works_on_status"
  end

  add_foreign_key "group_acls", "acls"
  add_foreign_key "group_acls", "groups"
  add_foreign_key "group_acls", "roles"
  add_foreign_key "users", "groups"
  add_foreign_key "users", "roles"
  add_foreign_key "works", "claims"
end
