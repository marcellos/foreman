class Model < ActiveRecord::Base
  has_many :hosts
  before_destroy Ensure_not_used_by.new(:hosts)
  validates_uniqueness_of :name
  validates_presence_of :name
  default_scope :order => 'name'

  alias_attribute :to_s, :name
  alias_attribute :to_label, :name
end
