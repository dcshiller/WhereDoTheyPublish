class Createaffinities < ActiveRecord::Migration[5.0]
  def change
    create_table "affinities" do |t|
      t.integer "first_journal_id"
      t.integer "second_journal_id"
      t.float "affinity"
      t.timestamps
    end
    add_index :affinities, ["first_journal_id", "second_journal_id"], unique: true
  end
end