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

ActiveRecord::Schema.define(version: 2021_10_25_020537) do

  create_table "attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "claim_id", null: false
    t.string "attachment"
    t.boolean "is_public", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["claim_id"], name: "index_attachments_on_claim_id"
  end

  create_table "claims", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "integration_id"
    t.bigint "application_id"
    t.integer "service_id"
    t.string "service_name"
    t.integer "ticket_identity"
    t.string "ticket_name"
    t.string "type"
    t.text "description"
    t.integer "status", limit: 1
    t.integer "priority", limit: 1
    t.integer "rating", limit: 1
    t.datetime "finished_at_plan"
    t.datetime "finished_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["application_id"], name: "index_claims_on_application_id"
    t.index ["integration_id", "application_id", "ticket_identity"], name: "claim_by_integration_application_ticket_identity", unique: true
    t.index ["priority"], name: "index_claims_on_priority"
    t.index ["service_id"], name: "index_claims_on_service_id"
    t.index ["status"], name: "index_claims_on_status"
    t.index ["ticket_identity"], name: "index_claims_on_ticket_identity"
  end

  create_table "departments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "dept"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "event_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "name", limit: 1
    t.string "description"
    t.string "template"
    t.boolean "is_public", default: false
    t.integer "order"
    t.index ["is_public"], name: "index_event_types_on_is_public"
    t.index ["name"], name: "index_event_types_on_name"
  end

  create_table "groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "department_id"
    t.string "name", limit: 45
    t.string "description"
    t.index ["department_id"], name: "index_groups_on_department_id"
    t.index ["name"], name: "index_groups_on_name"
  end

  create_table "histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "work_id", null: false
    t.bigint "user_id", null: false
    t.bigint "event_type_id", null: false
    t.text "action"
    t.json "user_info"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_type_id"], name: "index_histories_on_event_type_id"
    t.index ["user_id"], name: "index_histories_on_user_id"
    t.index ["work_id"], name: "index_histories_on_work_id"
  end

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "claim_id"
    t.bigint "work_id"
    t.bigint "sender_id", null: false
    t.string "type"
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["claim_id"], name: "index_messages_on_claim_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
    t.index ["work_id"], name: "index_messages_on_work_id"
  end

  create_table "oauth_access_grants", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri"
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "parameters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "claim_id", null: false
    t.string "name", null: false
    t.text "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["claim_id"], name: "index_parameters_on_claim_id"
  end

  create_table "roles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 45
    t.string "description"
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "source_snapshots", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "claim_id", null: false
    t.integer "id_tn"
    t.integer "tn"
    t.string "fio"
    t.integer "dept"
    t.json "user_attrs"
    t.string "domain_user", limit: 45
    t.string "dns"
    t.string "source_ip", limit: 15
    t.string "destination_ip", limit: 15
    t.string "mac", limit: 48
    t.string "invent_num", limit: 64
    t.integer "svt_item_id"
    t.bigint "barcode"
    t.string "host_location"
    t.string "os", limit: 64
    t.string "netbios", limit: 15
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["claim_id"], name: "index_source_snapshots_on_claim_id"
    t.index ["dept"], name: "index_source_snapshots_on_dept"
    t.index ["fio"], name: "index_source_snapshots_on_fio"
    t.index ["id_tn"], name: "index_source_snapshots_on_id_tn"
    t.index ["tn"], name: "index_source_snapshots_on_tn"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "group_id"
    t.integer "tn", null: false
    t.integer "id_tn", null: false
    t.string "login"
    t.string "fio", null: false
    t.string "work_tel", limit: 45
    t.string "mobile_tel", limit: 45
    t.string "email", limit: 45
    t.boolean "is_vacation", default: false
    t.boolean "is_default_worker", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["fio"], name: "index_users_on_fio"
    t.index ["group_id"], name: "index_users_on_group_id"
    t.index ["id_tn"], name: "index_users_on_id_tn"
    t.index ["is_default_worker"], name: "index_users_on_is_default_worker"
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["tn"], name: "index_users_on_tn"
  end

  create_table "workers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "work_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_workers_on_user_id"
    t.index ["work_id", "user_id"], name: "index_workers_on_work_id_and_user_id", unique: true
    t.index ["work_id"], name: "index_workers_on_work_id"
  end

  create_table "works", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "claim_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["claim_id", "group_id"], name: "index_works_on_claim_id_and_group_id", unique: true
    t.index ["claim_id"], name: "index_works_on_claim_id"
    t.index ["group_id"], name: "index_works_on_group_id"
  end

  add_foreign_key "attachments", "claims"
  add_foreign_key "claims", "oauth_applications", column: "application_id"
  add_foreign_key "groups", "departments"
  add_foreign_key "histories", "event_types"
  add_foreign_key "histories", "users"
  add_foreign_key "histories", "works"
  add_foreign_key "messages", "claims"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "messages", "works"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "parameters", "claims"
  add_foreign_key "source_snapshots", "claims"
  add_foreign_key "users", "groups"
  add_foreign_key "users", "roles"
  add_foreign_key "workers", "users"
  add_foreign_key "workers", "works"
  add_foreign_key "works", "claims"
  add_foreign_key "works", "groups"
end
