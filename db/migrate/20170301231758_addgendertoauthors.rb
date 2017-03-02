class Addgendertoauthors < ActiveRecord::Migration[5.0]
  def change
    add_column :authors, :gender, :float
  end
end
