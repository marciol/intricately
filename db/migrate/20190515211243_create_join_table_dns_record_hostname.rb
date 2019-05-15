class CreateJoinTableDNSRecordHostname < ActiveRecord::Migration[5.2]
  def change
    create_join_table :dns_records, :hostnames do |t|
      t.index [:dns_record_id, :hostname_id]
      t.index [:hostname_id, :dns_record_id]
    end
  end
end
