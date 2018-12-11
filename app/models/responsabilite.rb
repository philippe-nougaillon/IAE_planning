class Responsabilite < ActiveRecord::Base

  audited

  belongs_to :intervenant
  belongs_to :formation
end
