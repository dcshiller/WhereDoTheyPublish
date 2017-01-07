class Addcondensednametojournal < ActiveRecord::Migration[5.0]
  def change
    add_column :journals, :condensed_name, :string
    add_index :journals, :condensed_name
  end
end
