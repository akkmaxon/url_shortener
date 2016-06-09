class AddDescriptionToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :description, :text, default: ''
  end
end
