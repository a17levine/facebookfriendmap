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

ActiveRecord::Schema.define(version: 20141109221835) do

  create_table "attendees", force: true do |t|
    t.integer  "user_id"
    t.integer  "graph_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attendees", ["graph_id"], name: "index_attendees_on_graph_id"
  add_index "attendees", ["user_id"], name: "index_attendees_on_user_id"

  create_table "entrances", force: true do |t|
    t.string   "phone"
    t.string   "facebook_token"
    t.string   "user_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "graph_id"
    t.integer  "user_id"
  end

  create_table "friendships", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friendships", ["user_id"], name: "index_friendships_on_user_id"

  create_table "graphs", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "mutual_friendships", force: true do |t|
    t.integer  "user_at_party"
    t.integer  "user_at_party_2"
    t.integer  "mutual_friend"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "facebook_id"
    t.boolean  "at_party"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone"
    t.string   "facebook_pic_small"
  end

end
