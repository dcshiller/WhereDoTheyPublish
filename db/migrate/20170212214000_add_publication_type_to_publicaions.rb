class AddPublicationTypeToPublicaions < ActiveRecord::Migration[5.0]
  def change
    add_column :publications, :publication_type, :string, default: "article"
  end
end
