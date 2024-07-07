class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.integer :rate
      t.text :author_tip
      t.string :budget
      t.string :prep_time
      t.text :ingredients, array: true, default: []
      t.string :name
      t.string :author
      t.string :difficulty
      t.integer :people_quantity
      t.string :cook_time
      t.string :tags, array: true, default: []
      t.string :total_time
      t.string :image
      t.integer :nb_comments
      t.tsvector :text_search

      t.timestamps
    end
    add_index :recipes, :text_search, using: :gin
  end
end
