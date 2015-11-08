class Alert < ActiveRecord::Base
  belongs_to :user
  belongs_to :trail

  validates(:user, uniqueness: { scope: :trail, message: "alert already exists for this trail." })
end
