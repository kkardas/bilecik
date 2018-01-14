class CreateTickets < ActiveRecord::Migration[5.1]
  def change
    create_table :tickets do |t|
      t.float :price
      t.float :to_return
      t.belongs_to :event, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
