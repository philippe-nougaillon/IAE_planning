class Vacation < ActiveRecord::Base

  audited

  belongs_to :formation
  belongs_to :intervenant
end
