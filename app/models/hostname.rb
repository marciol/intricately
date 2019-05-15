# == Schema Information
#
# Table name: hostnames
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Hostname < ApplicationRecord
  validates_uniqueness_of :name
  validates_presence_of :name
  validates_format_of :name, with: /\A([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}\z/
end
