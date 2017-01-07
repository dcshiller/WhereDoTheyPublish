class Createpublicationtable < ActiveRecord::Migration[5.0]
  def change
    create_table "publications" do |t|
      t.string "title", index: true
      t.references :journal
      t.integer "publication_year"
      t.timestamps
    end

    create_table "authors" do |t|
      t.string "first_name"
      t.string "last_name", index: true
      t.string "middle_initial", default: ""
      t.timestamps
    end

    create_table "authorships" do |t|
      t.references :author
      t.references :publication
      t.timestamps
    end
  end
end
