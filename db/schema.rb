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

ActiveRecord::Schema.define(version: 20161209120007) do

  create_table "cours", force: :cascade do |t|
    t.datetime "debut"
    t.datetime "fin"
    t.integer  "formation_id"
    t.integer  "intervenant_id"
    t.integer  "salle_id"
    t.string   "ue"
    t.string   "nom"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
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
  end

  create_table "intervenants", force: :cascade do |t|
    t.string   "nom"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "prenom"
  end

  create_table "salles", force: :cascade do |t|
    t.string   "nom"
    t.integer  "places"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
