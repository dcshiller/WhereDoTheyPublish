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

ActiveRecord::Schema.define(version: 20170107145029) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_initial", default: ""
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["last_name"], name: "index_authors_on_last_name", using: :btree
  end

  create_table "authorships", force: :cascade do |t|
    t.integer  "author_id"
    t.integer  "publication_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["author_id"], name: "index_authorships_on_author_id", using: :btree
    t.index ["publication_id"], name: "index_authorships_on_publication_id", using: :btree
  end

  create_table "journals", force: :cascade do |t|
    t.string  "name"
    t.integer "official_version"
    t.boolean "economics",        default: false
    t.boolean "history",          default: false
    t.boolean "philosophy",       default: false
    t.boolean "psychology",       default: false
    t.string  "condensed_name"
    t.index ["condensed_name"], name: "index_journals_on_condensed_name", using: :btree
    t.index ["name"], name: "index_journals_on_name", using: :btree
  end

  create_table "publications", force: :cascade do |t|
    t.string   "title"
    t.integer  "journal_id"
    t.integer  "publication_year"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["journal_id"], name: "index_publications_on_journal_id", using: :btree
    t.index ["title"], name: "index_publications_on_title", using: :btree
  end

end