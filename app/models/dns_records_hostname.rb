class DNSRecordsHostname < ApplicationRecord
  belongs_to :dns_record
  belongs_to :hostname
end
