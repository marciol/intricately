require 'test_helper'

class Api::V1::DNSRecordsControllerTest < ActionDispatch::IntegrationTest
  test "creates a dns_record with associations" do
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
    assert JSON.parse(@response.body, symbolize_names: true) == {data: {id: record.id}}
  end

  test "returns 422 status with error message" do
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
end
