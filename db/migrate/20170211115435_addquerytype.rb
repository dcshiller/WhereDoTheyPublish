class Addquerytype < ActiveRecord::Migration[5.0]
  def change
    add_column :scheduled_queries, :query_type, :string
  end
end
