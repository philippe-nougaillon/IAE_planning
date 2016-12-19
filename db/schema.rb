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

ActiveRecord::Schema.define(version: 20161219095432) do

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index"
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index"
  add_index "audits", ["created_at"], name: "index_audits_on_created_at"
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid"
  add_index "audits", ["user_id", "user_type"], name: "user_index"

  create_table "cours", force: :cascade do |t|
    t.datetime "debut"
    t.datetime "fin"
    t.integer  "formation_id"
    t.integer  "intervenant_id"
    t.integer  "salle_id"
    t.string   "ue"
    t.string   "nom"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "etat",           default: 0
  end

  add_index "cours", ["formation_id"], name: "index_cours_on_formation_id"
  add_index "cours", ["intervenant_id"], name: "index_cours_on_intervenant_id"
  add_index "cours", ["salle_id"], name: "index_cours_on_salle_id"

  create_table "formations", force: :cascade do |t|
    t.string   "nom"
    t.string   "promo"
    t.string   "diplome"
    t.string   "domaine"
    t.boolean  "apprentissage"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "memo"
    t.integer  "nbr_etudiants"
  end

  create_table "intervenants", force: :cascade do |t|
    t.string   "nom"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "prenom"
    t.string   "email"
  end

  create_table "salles", force: :cascade do |t|
    t.string   "nom"
    t.integer  "places"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unites", force: :cascade do |t|
    t.integer  "formation_id"
    t.string   "nom"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "num"
  end

  add_index "unites", ["formation_id"], name: "index_unites_on_formation_id"

# Could not dump table "users" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

end
