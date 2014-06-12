class AddTitleToWebResource < ActiveRecord::Migration
  def change

    add_column :web_resources, :title, :text

  end
end
