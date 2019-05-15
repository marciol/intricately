# == Schema Information
#
# Table name: hostnames
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class HostnameTest < ActiveSupport::TestCase
  test "validates presence of name" do
    hostname = Hostname.new
    refute hostname.save
  end

  test "validates uniqueness of name" do
    local_one_hostname = hostnames(:one)
    hostname = Hostname.new(name: local_one_hostname.name)
    refute hostname.save
  end

  test "validates format of name" do
    hostname = Hostname.new(name: "foo.bar.123")
    refute hostname.save
  end
end
