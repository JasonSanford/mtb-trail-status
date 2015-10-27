class Trail < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug

  SOURCE_TARHEEL_TRAILBLAZERS = 'tarheel'
  SOURCE_USNWC                = 'usnwc'

  validates_uniqueness_of :name, :slug, :display_name

  def display_name
    read_attribute(:display_name) || name
  end
end
