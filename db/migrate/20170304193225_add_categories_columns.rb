class AddCategoriesColumns < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'hstore'
    add_column :journals, :categorization, :hstore, default: {}, null: false
    add_column :authors, :categorization, :hstore, default: {}, null: false
    add_column :publications, :categorization, :hstore, default: {}, null: false
  end
end
