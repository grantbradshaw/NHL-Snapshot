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

ActiveRecord::Schema.define(version: 20160131010124) do

  create_table "collections", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "shared",     default: false
    t.string   "title",      default: "My Collection"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "league_stats", force: :cascade do |t|
    t.string   "search_term"
    t.integer  "rank"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "saved_phrases", force: :cascade do |t|
    t.integer "collection_id"
    t.string  "phrase"
  end

  create_table "team_stats", force: :cascade do |t|
    t.string   "team"
    t.string   "rank"
    t.string   "top_player"
    t.string   "top_player_photo"
    t.string   "top_goalie"
    t.string   "top_goalie_photo"
    t.string   "next_game"
    t.string   "last_game"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "tweets", force: :cascade do |t|
    t.string   "search_term"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "upvotes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "collection_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
