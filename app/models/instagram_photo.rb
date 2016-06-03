class InstagramPhoto < ActiveRecord::Base
  belongs_to :trail

  validates :short_code, uniqueness: true

  scope :processed, -> { where(processed: true) }

  def oembed_url
    "https://api.instagram.com/oembed/?url=http://instagr.am/p/#{short_code}/&omitscript=true"
  end

  def obj_hash
    @obj_hash ||= JSON.parse(json)
  end
end