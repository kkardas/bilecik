class AddMyColumnToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :size, :integer
  end
end
