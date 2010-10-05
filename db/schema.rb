# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101005105035) do

  create_table "activities", :force => true do |t|
    t.string   "type"
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "controller"
    t.string   "action"
    t.boolean  "notified",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "private",        :default => false
    t.boolean  "hidden",         :default => false
  end

  add_index "activities", ["group_id"], :name => "index_activities_on_group_id"
  add_index "activities", ["trackable_type", "trackable_id"], :name => "index_activities_on_trackable_type_and_trackable_id"
  add_index "activities", ["type"], :name => "index_activities_on_type"
  add_index "activities", ["user_id"], :name => "index_activities_on_user_id"

  create_table "assets", :force => true do |t|
    t.string   "type"
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "private",           :default => false
    t.boolean  "hidden",            :default => false
  end

  add_index "assets", ["group_id"], :name => "index_assets_on_group_id"
  add_index "assets", ["user_id"], :name => "index_assets_on_user_id"

  create_table "clips", :force => true do |t|
    t.integer  "content_id"
    t.integer  "asset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clips", ["content_id", "asset_id"], :name => "index_clips_on_content_id_and_asset_id"

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.string   "subject"
    t.text     "body"
    t.integer  "parent_id"
    t.integer  "position",         :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_type", "commentable_id"], :name => "index_comments_on_commentable_type_and_commentable_id"
  add_index "comments", ["group_id"], :name => "index_comments_on_group_id"
  add_index "comments", ["parent_id"], :name => "index_comments_on_parent_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "contents", :force => true do |t|
    t.string   "type"
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "title"
    t.text     "body"
    t.boolean  "comments_enabled", :default => true
    t.integer  "comments_count",   :default => 0
    t.integer  "parent_id"
    t.string   "parent_type"
    t.integer  "position",         :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "private",          :default => false
    t.boolean  "hidden",           :default => false
    t.boolean  "delta",            :default => true,  :null => false
    t.boolean  "locked",           :default => false
    t.boolean  "boolean",          :default => false
    t.datetime "locked_at"
    t.integer  "locked_by_id"
    t.string   "permalink"
  end

  add_index "contents", ["group_id"], :name => "index_contents_on_group_id"
  add_index "contents", ["parent_id", "parent_type"], :name => "index_contents_on_parent_id_and_parent_type"
  add_index "contents", ["permalink"], :name => "index_contents_on_permalink"
  add_index "contents", ["user_id"], :name => "index_contents_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "private",             :default => false
    t.boolean  "hidden",              :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "delta",               :default => true,  :null => false
  end

  create_table "message_recipients", :force => true do |t|
    t.integer  "message_id"
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "message_recipients", ["message_id", "recipient_id"], :name => "index_message_recipients_on_message_id_and_recipient_id", :unique => true

  create_table "messages", :force => true do |t|
    t.string   "type"
    t.integer  "sender_id"
    t.string   "subject"
    t.text     "body"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["parent_id"], :name => "index_messages_on_parent_id"
  add_index "messages", ["sender_id"], :name => "index_messages_on_sender_id"

  create_table "notification_preferences", :force => true do |t|
    t.integer  "user_id"
    t.integer  "context_id"
    t.string   "context_type"
    t.string   "event"
    t.string   "notification_type"
    t.string   "notification_period"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notification_preferences", ["user_id", "context_id", "context_type"], :name => "with_context"
  add_index "notification_preferences", ["user_id"], :name => "index_notification_preferences_on_user_id"

  create_table "notifications", :force => true do |t|
    t.integer  "activity_id"
    t.integer  "user_id"
    t.boolean  "for_digest"
    t.boolean  "sent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "prefix"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "suffix"
    t.string   "full_name"
    t.string   "previous_full_name"
    t.string   "nickname"
    t.datetime "date_of_birth"
    t.string   "sex",                :limit => 1, :default => ""
    t.text     "about"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "skype"
    t.string   "twitter"
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id", :unique => true

  create_table "received_messages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "message_id"
    t.boolean  "read",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "received_messages", ["user_id", "message_id"], :name => "index_received_messages_on_user_id_and_message_id"

  create_table "relationships", :force => true do |t|
    t.string   "type"
    t.integer  "user_id"
    t.integer  "relatable_id"
    t.string   "relatable_type"
    t.boolean  "confirmed",      :default => false
    t.integer  "request_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["type", "user_id", "relatable_type", "relatable_id"], :name => "unique_relationship", :unique => true

  create_table "sent_messages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sent_messages", ["user_id", "message_id"], :name => "index_sent_messages_on_user_id_and_message_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                  :null => false
    t.boolean  "confirmed",           :default => false
    t.string   "crypted_password",    :default => "",    :null => false
    t.string   "password_salt",       :default => "",    :null => false
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.integer  "contents_count",      :default => 0
    t.integer  "comments_count",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "delta",               :default => true,  :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token", :unique => true
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token", :unique => true
  add_index "users", ["single_access_token"], :name => "index_users_on_single_access_token", :unique => true

  create_table "versions", :force => true do |t|
    t.integer  "versioned_id"
    t.string   "versioned_type"
    t.text     "changes"
    t.integer  "number"
    t.datetime "created_at"
  end

  add_index "versions", ["created_at"], :name => "index_versions_on_created_at"
  add_index "versions", ["number"], :name => "index_versions_on_number"
  add_index "versions", ["versioned_type", "versioned_id"], :name => "index_versions_on_versioned_type_and_versioned_id"

end
