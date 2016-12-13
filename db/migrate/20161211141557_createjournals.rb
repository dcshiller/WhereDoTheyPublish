class Createjournals < ActiveRecord::Migration[5.0]
  def change
    create_table "journals" do |t|
      t.string "name", index: true
      t.integer "official_version"
      t.boolean "economics", default: false
      t.boolean "history", default: false
      t.boolean "philosophy", default: false
      t.boolean "psychology", default: false
    end
  end
end
