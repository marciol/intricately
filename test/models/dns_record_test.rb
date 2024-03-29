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

  test "creates a dns_record with associations" do
    record = DNSRecord.new(
      ip_address: '80.104.176.249',
      hostnames: [
        Hostname.find_or_initialize_by(name: 'local.one'),
        Hostname.find_or_initialize_by(name: 'local.three')
      ]
    )

    assert record.save
    assert record.hostnames.map(&:name) == ['local.one', 'local.three']
  end

  test "does not create dns_record when some associated hostname is invalid" do
    record = DNSRecord.new(
      ip_address: '80.104.176.249',
      hostnames: [
        Hostname.find_or_initialize_by(name: 'local.one'),
        Hostname.find_or_initialize_by(name: '')
      ]
    )

    refute record.save
    assert record.errors.full_messages == [
      "Hostnames[1] name can't be blank",
      "Hostnames[1] name is invalid"
    ]
  end

  test "returns dns_records correctly filtered by given criteria" do
    create_dns_record ip_address: '1.1.1.1', hostnames: ['lorem.com', 'ipsum.com', 'dolor.com', 'amet.com']
    create_dns_record ip_address: '2.2.2.2', hostnames: ['ipsum.com']
    create_dns_record ip_address: '3.3.3.3', hostnames: ['ipsum.com', 'dolor.com', 'amet.com']
    create_dns_record ip_address: '4.4.4.4', hostnames: ['ipsum.com', 'dolor.com', 'sit.com', 'amet.com']
    create_dns_record ip_address: '5.5.5.5', hostnames: ['dolor.com', 'sit.com']

    result = DNSRecord.filter_records(
      include_hostnames: ['ipsum.com', 'dolor.com'],
      exclude_hostnames: ['sit.com'],
      page: 1,
      per_page: 1
    )
    assert result.records.size == 1
    assert result.records.first == DNSRecord.where(ip_address: '1.1.1.1').first
    assert result.total == 2

    result = DNSRecord.filter_records(
      include_hostnames: ['ipsum.com', 'dolor.com'],
      exclude_hostnames: ['sit.com'],
      page: 2,
      per_page: 1
    )
    assert result.records.size == 1
    assert result.records.first == DNSRecord.where(ip_address: '3.3.3.3').first
    assert result.total == 2

    result = DNSRecord.filter_records
    assert result.records.size == 8
    assert result.records.sort == DNSRecord.all.sort
    assert result.total == 8
  end

  def create_dns_record(ip_address:, hostnames:)
    DNSRecord.create(
      ip_address: ip_address,
      hostnames: hostnames.map do |name|
        Hostname.find_or_initialize_by(name: name)
      end
    )
  end
end
