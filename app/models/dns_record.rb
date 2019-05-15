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
  has_many :dns_records_hostnames
  has_many :hostnames, through: :dns_records_hostnames, index_errors: true
  accepts_nested_attributes_for :hostnames

  validates_uniqueness_of :ip_address
  validates_presence_of :ip_address
end
