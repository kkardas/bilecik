class Event < ApplicationRecord
  has_many :tickets, dependent: :destroy
  validates_presence_of :name, :description, :price, :date, :image, :size, :message => "nie może pozostać puste"
  validate :event_date_cannot_be_in_the_past
  validates_numericality_of  :size, :price, :greater_than => 0, :message => "musi być większa od zera"

  def event_date_cannot_be_in_the_past
    errors.add(:date, "nie może być z przeszłości") if
        !date.blank? and date < Date.today
  end

end
