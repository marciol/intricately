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
  has_many :hostnames, ->{ distinct },
    through: :dns_records_hostnames,
    index_errors: true
  accepts_nested_attributes_for :hostnames

  validates_uniqueness_of :ip_address
  validates_presence_of :ip_address

  def self.filter_records(include_hostnames: [], exclude_hostnames: [], page: 1, per_page: 20)
    query =
      DNSRecord
        .select("*")
        .from(
          DNSRecord
            .left_joins(:hostnames)
            .select("dns_records.*, array_agg(hostnames.name)::text[] as hostnames_array")
            .group("dns_records.id"), :dns_records_with_hostnames)

    query = unless include_hostnames.blank?
              query.where("dns_records_with_hostnames.hostnames_array @> ARRAY[?]", include_hostnames)
            else
              query
            end

    query = unless exclude_hostnames.blank?
              query.where.not("dns_records_with_hostnames.hostnames_array @> ARRAY[?]", exclude_hostnames)
            else
              query
            end

    total = query.size
    records =
      query
      .limit(per_page)
      .offset(per_page * (page - 1))
      .to_a

    OpenStruct.new(total: total, records: records)
  end
end
