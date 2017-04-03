class AddDatatToAuthors < ActiveRecord::Migration[5.0]
  def change
    create_table :institutions do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :affiliations do |t|
      t.references :institution, null: false, index: true
      t.references :author, null: false, index: true
      t.integer :start_year
      t.integer :end_year
      t.string :affiliation_type
      t.timestamps
    end

    add_column :authors, :birth_year, :integer
    add_column :authors, :death_year, :integer
  end
end
