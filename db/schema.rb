# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20190507135448) do

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id",    limit: 4
    t.string   "auditable_type",  limit: 255
    t.integer  "associated_id",   limit: 4
    t.string   "associated_type", limit: 255
    t.integer  "user_id",         limit: 4
    t.string   "user_type",       limit: 255
    t.string   "username",        limit: 255
    t.string   "action",          limit: 255
    t.text     "audited_changes", limit: 65535
    t.integer  "version",         limit: 4,     default: 0
    t.string   "comment",         limit: 255
    t.string   "remote_address",  limit: 255
    t.string   "request_uuid",    limit: 255
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "cours", force: :cascade do |t|
    t.datetime "debut"
    t.datetime "fin"
    t.integer  "formation_id",            limit: 4
    t.integer  "intervenant_id",          limit: 4
    t.integer  "salle_id",                limit: 4
    t.string   "ue",                      limit: 255
    t.string   "nom",                     limit: 255
    t.datetime "created_at",                                                                null: false
    t.datetime "updated_at",                                                                null: false
    t.integer  "etat",                    limit: 4,                           default: 0
    t.decimal  "duree",                               precision: 4, scale: 2, default: 0.0
    t.integer  "intervenant_binome_id",   limit: 4
    t.boolean  "hors_service_statutaire"
    t.string   "commentaires",            limit: 255
    t.boolean  "elearning"
  end

  add_index "cours", ["debut"], name: "index_cours_on_debut", using: :btree
  add_index "cours", ["etat"], name: "index_cours_on_etat", using: :btree
  add_index "cours", ["formation_id"], name: "index_cours_on_formation_id", using: :btree
  add_index "cours", ["intervenant_id"], name: "index_cours_on_intervenant_id", using: :btree
  add_index "cours", ["salle_id"], name: "index_cours_on_salle_id", using: :btree

  create_table "documents", force: :cascade do |t|
    t.string   "nom",            limit: 255
    t.integer  "formation_id",   limit: 4
    t.integer  "intervenant_id", limit: 4
    t.integer  "unite_id",       limit: 4
    t.string   "fichier",        limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "documents", ["formation_id"], name: "index_documents_on_formation_id", using: :btree
  add_index "documents", ["intervenant_id"], name: "index_documents_on_intervenant_id", using: :btree
  add_index "documents", ["unite_id"], name: "index_documents_on_unite_id", using: :btree

  create_table "etudiants", force: :cascade do |t|
    t.integer  "formation_id", limit: 4
    t.string   "nom",          limit: 255
    t.string   "prénom",       limit: 255
    t.string   "email",        limit: 255
    t.string   "mobile",       limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "etudiants", ["formation_id"], name: "index_etudiants_on_formation_id", using: :btree

  create_table "fermetures", force: :cascade do |t|
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "fermetures", ["date"], name: "index_fermetures_on_date", using: :btree

  create_table "formations", force: :cascade do |t|
    t.string   "nom",             limit: 255
    t.string   "promo",           limit: 255
    t.string   "diplome",         limit: 255
    t.string   "domaine",         limit: 255
    t.boolean  "apprentissage"
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.string   "memo",            limit: 255
    t.integer  "nbr_etudiants",   limit: 4,                            default: 0
    t.integer  "nbr_heures",      limit: 4
    t.string   "abrg",            limit: 255
    t.integer  "user_id",         limit: 4
    t.string   "color",           limit: 255
    t.string   "Forfait_HETD",    limit: 255
    t.decimal  "Taux_TD",                     precision: 10, scale: 2, default: 0.0
    t.string   "Code_Analytique", limit: 255
    t.boolean  "hors_catalogue",                                       default: false
    t.boolean  "archive"
    t.boolean  "hss"
  end

  add_index "formations", ["archive"], name: "index_formations_on_archive", using: :btree
  add_index "formations", ["user_id"], name: "index_formations_on_user_id", using: :btree

  create_table "import_log_lines", force: :cascade do |t|
    t.integer  "import_log_id", limit: 4
    t.integer  "num_ligne",     limit: 4
    t.integer  "etat",          limit: 4
    t.text     "message",       limit: 65535
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "import_log_lines", ["import_log_id"], name: "index_import_log_lines_on_import_log_id", using: :btree

  create_table "import_logs", force: :cascade do |t|
    t.string   "model_type",       limit: 255
    t.integer  "etat",             limit: 4
    t.integer  "nbr_lignes",       limit: 4
    t.integer  "lignes_importees", limit: 4
    t.string   "fichier",          limit: 255
    t.string   "message",          limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "user_id",          limit: 4
  end

  add_index "import_logs", ["user_id"], name: "index_import_logs_on_user_id", using: :btree

  create_table "intervenants", force: :cascade do |t|
    t.string   "nom",                   limit: 255
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "prenom",                limit: 255
    t.string   "email",                 limit: 255
    t.string   "linkedin_url",          limit: 255
    t.string   "titre1",                limit: 255
    t.string   "titre2",                limit: 255
    t.string   "spécialité",            limit: 255
    t.string   "téléphone_fixe",        limit: 255
    t.string   "téléphone_mobile",      limit: 255
    t.string   "bureau",                limit: 255
    t.string   "photo",                 limit: 255
    t.integer  "status",                limit: 4
    t.datetime "remise_dossier_srh"
    t.string   "adresse",               limit: 255
    t.string   "cp",                    limit: 255
    t.string   "ville",                 limit: 255
    t.boolean  "doublon"
    t.integer  "nbr_heures_statutaire", limit: 4
    t.date     "date_naissance"
    t.string   "memo",                  limit: 255
  end

  create_table "responsabilites", force: :cascade do |t|
    t.integer  "intervenant_id", limit: 4
    t.string   "titre",          limit: 255
    t.decimal  "heures",                     precision: 5, scale: 2
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.date     "debut"
    t.date     "fin"
    t.integer  "formation_id",   limit: 4
    t.string   "commentaires",   limit: 255
  end

  add_index "responsabilites", ["formation_id"], name: "index_responsabilites_on_formation_id", using: :btree
  add_index "responsabilites", ["intervenant_id"], name: "index_responsabilites_on_intervenant_id", using: :btree

  create_table "salles", force: :cascade do |t|
    t.string   "nom",        limit: 255
    t.integer  "places",     limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "bloc",       limit: 255
  end

  create_table "unites", force: :cascade do |t|
    t.integer  "formation_id", limit: 4
    t.string   "nom",          limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "num",          limit: 255
  end

  add_index "unites", ["formation_id"], name: "index_unites_on_formation_id", using: :btree
  add_index "unites", ["num"], name: "index_unites_on_num", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                              default: false
    t.integer  "formation_id",           limit: 4
    t.string   "nom",                    limit: 255
    t.string   "prénom",                 limit: 255
    t.string   "mobile",                 limit: 255
    t.boolean  "reserver"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["formation_id"], name: "index_users_on_formation_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vacations", force: :cascade do |t|
    t.integer  "formation_id",   limit: 4
    t.integer  "intervenant_id", limit: 4
    t.string   "titre",          limit: 255
    t.decimal  "forfaithtd",                 precision: 5, scale: 2
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.date     "date"
    t.integer  "qte",            limit: 4
    t.string   "commentaires",   limit: 255
  end

  add_index "vacations", ["formation_id"], name: "index_vacations_on_formation_id", using: :btree
  add_index "vacations", ["intervenant_id"], name: "index_vacations_on_intervenant_id", using: :btree

  add_foreign_key "import_log_lines", "import_logs"
  add_foreign_key "import_logs", "users"
  add_foreign_key "responsabilites", "formations"
  add_foreign_key "responsabilites", "intervenants"
  add_foreign_key "vacations", "formations"
  add_foreign_key "vacations", "intervenants"
end
