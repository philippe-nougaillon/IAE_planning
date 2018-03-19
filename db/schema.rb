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

ActiveRecord::Schema.define(version: 20180319165741) do

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
    t.boolean  "hors_service_statutaire", limit: 1
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
    t.boolean  "apprentissage",   limit: 1
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
    t.boolean  "hors_catalogue",  limit: 1,                            default: false
    t.boolean  "archive",         limit: 1
  end

  add_index "formations", ["archive"], name: "index_formations_on_archive", using: :btree
  add_index "formations", ["user_id"], name: "index_formations_on_user_id", using: :btree

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
    t.boolean  "doublon",               limit: 1
    t.integer  "nbr_heures_statutaire", limit: 4
    t.date     "date_naissance"
    t.string   "memo",                  limit: 255
  end

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
    t.boolean  "admin",                  limit: 1,   default: false
    t.integer  "formation_id",           limit: 4
    t.string   "nom",                    limit: 255
    t.string   "prénom",                 limit: 255
    t.string   "mobile",                 limit: 255
    t.boolean  "reserver",               limit: 1
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["formation_id"], name: "index_users_on_formation_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
