class Adddisplaytitletojournals < ActiveRecord::Migration[5.0]
  def change
    add_column :journals, :display_name, :string
  end
end
