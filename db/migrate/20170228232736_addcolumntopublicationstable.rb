class Addcolumntopublicationstable < ActiveRecord::Migration[5.0]
  def change
    add_column :publications, :volume, :integer, index: true
    add_column :publications, :number, :string
    add_column :publications, :pages, :string
  end
end
