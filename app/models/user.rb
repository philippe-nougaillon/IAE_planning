class User < ActiveRecord::Base
  audited

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable :registerable,
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :formation       

end
