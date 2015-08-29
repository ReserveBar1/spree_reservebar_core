class AddColumnDataToSpreeSuggestions < ActiveRecord::Migration
  def change
    add_column :spree_suggestions, :data, :string
  end
end
