# == Schema Information
#
# Table name: dns_records
#
#  id         :bigint           not null, primary key
#  ip_address :cidr
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DNSRecord < ApplicationRecord
  validates_uniqueness_of :ip_address
  validates_presence_of :ip_address
end
