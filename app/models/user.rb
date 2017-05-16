# Encoding: UTF-8

class User < ActiveRecord::Base
  audited
  

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable :registerable,
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :formation   

  validates :nom, :prénom, presence:true    

  default_scope { order(:nom, :prénom) } 

end
