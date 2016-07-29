class AddSpinaCategoryIdToSpinaArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :spina_articles, :category_id, :integer
  end
end
