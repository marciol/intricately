require 'test_helper'

class Api::V1::DNSRecordsControllerTest < ActionDispatch::IntegrationTest
  test "POST /api/v1/dns_records - creates a dns_record with associations" do
    dns_record_params = {
      dns_record: {
        ip_address: '80.104.176.249',
        hostnames: [
          'local.one', 'local.three'
        ]
      }
    }

    post api_v1_dns_records_url, params: dns_record_params

    assert_response :success

    record = DNSRecord.where(ip_address: '80.104.176.249').first
    assert JSON.parse(@response.body, symbolize_names: true) == {id: record.id}
  end

  test "POST /api/v1/dns_records - returns 422 status with error message" do
    dns_record_params = {
      dns_record: {
        ip_address: 'a.b.c.d',
        hostnames: [
          'local.one', ''
        ]
      }
    }

    post api_v1_dns_records_url, params: dns_record_params

    assert_response :unprocessable_entity
    assert JSON.parse(@response.body, symbolize_names: true) == {
      errors: [
        "Hostnames[1] name can't be blank",
        "Hostnames[1] name is invalid",
        "Ip address can't be blank"
      ]
    }
  end

  test "GET /api/v1/dns_records - returns only records filtered by given criteria" do
    create_dns_record ip_address: '1.1.1.1', hostnames: ['lorem.com', 'ipsum.com', 'dolor.com', 'amet.com']
    create_dns_record ip_address: '2.2.2.2', hostnames: ['ipsum.com']
    create_dns_record ip_address: '3.3.3.3', hostnames: ['ipsum.com', 'dolor.com', 'amet.com']
    create_dns_record ip_address: '4.4.4.4', hostnames: ['ipsum.com', 'dolor.com', 'sit.com', 'amet.com']
    create_dns_record ip_address: '5.5.5.5', hostnames: ['dolor.com', 'sit.com']

    get api_v1_dns_records_url, params: {
      include_hostnames: ['ipsum.com', 'dolor.com'],
      exclude_hostnames: ['sit.com'],
      page: 1
    }

    records = DNSRecord.where(
      ip_address: ['1.1.1.1', '3.3.3.3']
    )

    assert_response :success

    response = JSON.parse(@response.body)
    assert response["total_matching_dns_records"] == 2
    assert response["matching_dns_records"].sort_by {
      |m| m["id"]
    } == [
      {
        "id" => records[0].id,
        "ip_address" => '1.1.1.1'
      },
      {
        "id" => records[1].id,
        "ip_address" => '3.3.3.3'
      }
    ]
    assert response["associated_hostnames"] ==
      records
        .flat_map(&:hostnames)
        .map(&:name)
        .reduce(Hash.new(0)) { |h, v| h[v] += 1; h }
  end

  test "GET /api/v1/dns_records - returns all records without the optional parameters" do
    get api_v1_dns_records_url

    records = DNSRecord.all.sort_by { |r| r.ip_address.to_s }

    assert_response :success

    response = JSON.parse(@response.body)
    assert response["total_matching_dns_records"] == 3
    response["matching_dns_records"].sort_by { |r|
      r["ip_address"]
    } == [
      {
        "id" => records[0].id,
        "ip_address" => '0.0.0.0'
      },
      {
        "id" => records[1].id,
        "ip_address" => '127.0.0.1'
      },
      {
        "id" => records[2].id,
        "ip_address" => '8.8.8.8'
      }
    ]
    assert response["associated_hostnames"] == {
      "local.one" => 2,
      "local.two" => 2
    }
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
