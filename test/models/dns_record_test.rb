# == Schema Information
#
# Table name: dns_records
#
#  id         :bigint           not null, primary key
#  ip_address :cidr
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class DNSRecordTest < ActiveSupport::TestCase
  test "creates a valid record" do
    record = DNSRecord.new(ip_address: '80.104.176.249')
    assert record.save
  end

  test "does not create a duplicated record" do
    existent_record = dns_records(:loopback)
    record = DNSRecord.new(ip_address: existent_record.ip_address.to_s)
    refute record.save
  end

  test "does not create a record with invalid dns format" do
    record = DNSRecord.new(ip_address: 'a.b.c.d')
    refute record.save
  end
end
