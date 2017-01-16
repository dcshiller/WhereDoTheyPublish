class AddScheduledQueries < ActiveRecord::Migration[5.0]
  def change
    create_table :scheduled_queries do |t|
      t.string :query
      t.string :type
      t.integer :start
      t.integer :end
      t.boolean :complete, default: false
    end
  end
end
