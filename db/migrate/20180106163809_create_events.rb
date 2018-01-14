class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.float :price
      t.date :date
      t.boolean :adult_only
      t.string :image

      t.timestamps
    end
  end
end
