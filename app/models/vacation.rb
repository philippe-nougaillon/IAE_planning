class Vacation < ActiveRecord::Base
  belongs_to :formation
  belongs_to :intervenant
end
