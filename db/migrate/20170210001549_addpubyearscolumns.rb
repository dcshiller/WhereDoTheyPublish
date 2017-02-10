class Addpubyearscolumns < ActiveRecord::Migration[5.0]
  def change
    add_column :journals, :publication_start, :integer
    add_column :journals, :publication_end, :integer
  end
end
