class Responsabilite < ActiveRecord::Base
  belongs_to :intervenant
  belongs_to :formation
end
