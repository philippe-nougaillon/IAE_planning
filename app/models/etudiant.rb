# Encoding: utf-8

class Etudiant < ApplicationRecord

  audited
  
  validates :nom, :prénom, :civilité, presence: true
  # validates :nom, uniqueness: {scope: [:formation_id]}

  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 
  
  belongs_to :formation

  def self.xls_headers
		%w{Id Nom Prénom Email Mobile Formation_id Formation_nom Créé_le Modifié_le}  
	end

	def self.generate_xls(etudiants)
		require 'spreadsheet'    
		
		Spreadsheet.client_encoding = 'UTF-8'
	
		book = Spreadsheet::Workbook.new
		sheet = book.create_worksheet name: 'Etudiants'
		bold = Spreadsheet::Format.new :weight => :bold, :size => 10
	
		sheet.row(0).concat Etudiant.xls_headers
		sheet.row(0).default_format = bold
		
		index = 1
		etudiants.each do |i|
      fields_to_export = [
          i.id, 
          i.nom, 
          i.prénom, 
          i.email, 
          i.mobile, 
          i.formation_id, 
          i.try(:formation).try(:nom), 
          i.created_at, 
          i.updated_at
      ]
       
			sheet.row(index).replace fields_to_export
			#logger.debug "#{index} #{fields_to_export}"
			index += 1
		end
	
		return book
  end
  
end
