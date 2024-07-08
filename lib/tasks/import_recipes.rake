require 'json'

namespace :import do
  desc "Import recipes from JSON file"
  task :recipes, [:filepath] => :environment do |task, args|
    filepath = args[:filepath]
    if filepath.nil?
      puts "Please provide a file path."
      exit
    end

    json_data = File.readlines(filepath).each do |line|
      recipe_data = JSON.parse(line)
      Recipe.create!(
        rate: recipe_data['rate'].to_i,
        author_tip: recipe_data['author_tip'],
        budget: recipe_data['budget'],
        prep_time: recipe_data['prep_time'],
        ingredients: recipe_data['ingredients'],
        name: recipe_data['name'],
        author: recipe_data['author'],
        difficulty: recipe_data['difficulty'],
        people_quantity: recipe_data['people_quantity'].to_i,
        cook_time: recipe_data['cook_time'],
        tags: recipe_data['tags'],
        total_time: recipe_data['total_time'],
        image: recipe_data['image'],
        nb_comments: recipe_data['nb_comments'].to_i
      )
    end
  end
end
