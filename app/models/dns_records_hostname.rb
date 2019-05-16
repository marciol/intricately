# == Schema Information
#
# Table name: dns_records_hostnames
#
#  dns_record_id :bigint           not null
#  hostname_id   :bigint           not null
#
# Indexes
#
#  index_dns_records_hostnames_on_dns_record_id_and_hostname_id  (dns_record_id,hostname_id)
#  index_dns_records_hostnames_on_hostname_id_and_dns_record_id  (hostname_id,dns_record_id)
#

class DNSRecordsHostname < ApplicationRecord
  belongs_to :dns_record
  belongs_to :hostname
end
