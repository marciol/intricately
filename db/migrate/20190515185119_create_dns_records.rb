class CreateDNSRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :dns_records do |t|
      t.cidr :ip_address

      t.timestamps
    end
  end
end
