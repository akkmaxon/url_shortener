class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :original
      t.string :short
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
