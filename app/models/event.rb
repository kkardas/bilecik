class Event < ApplicationRecord
  has_many :tickets, dependent: :destroy
  validates_presence_of :name, :description, :price, :date, :image, :size, :message => "nie może pozostać puste"
  validate :event_date_cannot_be_in_the_past
  validate :money_must_be_greater_than_zero

  def event_date_cannot_be_in_the_past
    errors.add(:date, "nie może być z przeszłości") if
        !date.blank? and date < Date.today
  end

  def money_must_be_greater_than_zero
    if :money < 0
      flash[:danger] = "Kwota doładowania musi być dodatnia"
    end
  end
end
