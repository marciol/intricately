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

ActiveRecord::Schema.define(version: 2019_05_15_211243) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dns_records", force: :cascade do |t|
    t.cidr "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dns_records_hostnames", id: false, force: :cascade do |t|
    t.bigint "dns_record_id", null: false
    t.bigint "hostname_id", null: false
    t.index ["dns_record_id", "hostname_id"], name: "index_dns_records_hostnames_on_dns_record_id_and_hostname_id"
    t.index ["hostname_id", "dns_record_id"], name: "index_dns_records_hostnames_on_hostname_id_and_dns_record_id"
  end

  create_table "hostnames", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
