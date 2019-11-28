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

ActiveRecord::Schema.define(version: 20191128001511) do

  create_table "answers", force: :cascade do |t|
    t.text "reply"
    t.integer "user_id"
    t.integer "document_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_answers_on_document_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "children", force: :cascade do |t|
    t.string "name_1"
    t.string "name_2"
    t.string "full_name"
    t.integer "teacher_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["teacher_id"], name: "index_children_on_teacher_id"
    t.index ["user_id"], name: "index_children_on_user_id"
  end

  create_table "document_items", force: :cascade do |t|
    t.text "content"
    t.string "radam"
    t.integer "document_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "select_check", default: false
    t.index ["document_id"], name: "index_document_items_on_document_id"
  end

  create_table "document_selects", force: :cascade do |t|
    t.text "content"
    t.integer "document_item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_item_id"], name: "index_document_selects_on_document_item_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "title"
    t.text "memo"
    t.text "pdf_link"
    t.date "deadline"
    t.string "randam"
    t.boolean "public", default: false
    t.integer "teacher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "item_check", default: false
    t.index ["teacher_id"], name: "index_documents_on_teacher_id"
  end

  create_table "meeting_times", force: :cascade do |t|
    t.datetime "time"
    t.string "name"
    t.integer "teacher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["teacher_id"], name: "index_meeting_times_on_teacher_id"
  end

  create_table "meetings", force: :cascade do |t|
    t.date "date"
    t.string "nottime"
    t.integer "status", default: 3
    t.boolean "desired", default: false
    t.string "randam"
    t.integer "teacher_id"
    t.integer "child_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["child_id"], name: "index_meetings_on_child_id"
    t.index ["teacher_id"], name: "index_meetings_on_teacher_id"
  end

  create_table "p_messages", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.text "reply"
    t.integer "user_id"
    t.integer "teacher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["teacher_id"], name: "index_p_messages_on_teacher_id"
    t.index ["user_id"], name: "index_p_messages_on_user_id"
  end

  create_table "t_messages", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.text "reply"
    t.string "select_user"
    t.integer "teacher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["teacher_id"], name: "index_t_messages_on_teacher_id"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "remember_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.string "name2"
    t.string "phone"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
