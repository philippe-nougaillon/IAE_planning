# Encoding: utf-8

class Etudiant < ActiveRecord::Base

  audited
  
  validates :nom, :prénom, :formation_id, presence: true
  validates :nom, uniqueness: {scope: [:formation_id]}

  validates :email, presence: true
  
  belongs_to :formation
end
