class CreateWebResources < ActiveRecord::Migration
  def change
    create_table :web_resources do |t|
      t.text :url
      t.integer :type
      t.binary :image
      t.text :html_original
      t.text :html_edited

      t.timestamps
    end
  end
end
