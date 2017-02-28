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

ActiveRecord::Schema.define(version: 20170228232736) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "affinities", force: :cascade do |t|
    t.integer  "first_journal_id"
    t.integer  "second_journal_id"
    t.float    "affinity"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["first_journal_id", "second_journal_id"], name: "index_affinities_on_first_journal_id_and_second_journal_id", unique: true, using: :btree
  end

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
    t.string  "condensed_name"
    t.integer "publication_start"
    t.integer "publication_end"
    t.string  "display_name"
    t.index ["condensed_name"], name: "index_journals_on_condensed_name", using: :btree
    t.index ["name"], name: "index_journals_on_name", using: :btree
  end

  create_table "publications", force: :cascade do |t|
    t.string   "title"
    t.integer  "journal_id"
    t.integer  "publication_year"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "display_title"
    t.string   "publication_type", default: "article"
    t.integer  "volume"
    t.string   "number"
    t.string   "pages"
    t.index ["journal_id"], name: "index_publications_on_journal_id", using: :btree
    t.index ["title"], name: "index_publications_on_title", using: :btree
  end

  create_table "scheduled_queries", force: :cascade do |t|
    t.string  "query"
    t.string  "type"
    t.integer "start"
    t.integer "end"
    t.boolean "complete",         default: false
    t.string  "query_type"
    t.integer "additional_count"
  end

end
