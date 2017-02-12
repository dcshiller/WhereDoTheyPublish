class Removecolumnsfromjournals < ActiveRecord::Migration[5.0]
  def change
    remove_column :journals, :economics
    remove_column :journals, :history
    remove_column :journals, :psychology
    remove_column :journals, :philosophy
  end
end
