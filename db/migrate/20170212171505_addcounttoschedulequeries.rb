class Addcounttoschedulequeries < ActiveRecord::Migration[5.0]
  def change
    add_column :scheduled_queries, :additional_count, :integer
  end
end
