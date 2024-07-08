require 'test_helper'
require 'rake'

class ImportRecipesTest < ActiveSupport::TestCase
  setup do
    Rake.application = Rake::Application.new
    Rake.application.rake_require "tasks/import_recipes"
    Rake::Task.define_task(:environment)
  end

  test "import recipes and search" do
    file_path = 'simple-recipe.json'
    recipe_data = File.readlines(file_path).map{ |l| JSON.parse(l)}.first

    assert_difference 'Recipe.count', 1 do
      Rake::Task["import:recipes"].invoke(file_path)
    end

    imported_recipe = Recipe.find_by(name: recipe_data['name'])

    assert_not_nil imported_recipe
    assert_includes imported_recipe.ingredients, recipe_data['ingredients'].first

    search_term = recipe_data['ingredients'].first.split.first
    search_result = Recipe.where("text_search @@ to_tsquery(?)", search_term)
    assert_includes search_result, imported_recipe
  end
end
