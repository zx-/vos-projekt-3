class AddIndexToWebResourceUrl < ActiveRecord::Migration
  def change

    add_index :web_resources, :url

  end
end
