class AddIndexToPubType < ActiveRecord::Migration[5.0]
  def change
    add_index :publications, :publication_type
  end
end
