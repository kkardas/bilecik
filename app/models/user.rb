require 'digest/sha1'

class User < ApplicationRecord
  has_many :tickets, dependent: :destroy
  before_save :encrypt_password
  after_save :clear_password
  validates_presence_of :name, :password, :birth, :message => "nie może pozostać puste"
  validates_uniqueness_of :name, :message => "Podany login już jest w bazie danych"
  validate :birth_date_cannot_be_in_the_past
  validates_numericality_of  :money, :greater_than => 0, :message => "musi być większy od zera"

  def birth_date_cannot_be_in_the_past
    errors.add(:birth, "nie może być z przyszłości") if
        !birth.blank? and birth > Date.today
  end

  def encrypt_password
    if password.present?
      self.password = Digest::SHA1.hexdigest(password)
    end
  end

  def clear_password
    self.password = nil
  end

  def self.authenticate(username="", login_password="")
    user = User.find_by_name(username)
    if user && user.match_password(login_password)
      return user
    else
      return false
    end
  end

  def match_password(login_password="")
    password == Digest::SHA1.hexdigest(login_password)
  end
end
