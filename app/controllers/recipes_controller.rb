class RecipesController < ApplicationController

  before_action :validate_ingredients_query, only: [:search]

  def search
    @ingredients = params[:ingredients] || []
    ingredient = params[:ingredient]

    if params[:commit] == t(:remove)
      @ingredients.delete(params[:ingredient_to_remove])
    else
      @ingredients << ingredient if ingredient.present?
    end

    flash.now[:alert] = nil  # Ensure the alert flash is cleared on successful requests
    @recipes = Recipe.with_ingredients(@ingredients)
  end

  private

  # TODO: find all possible ways to break the full text search request
  # Currently, I'm only aware of sentences and the characters "&" "|" that can break it.
  #
  # TODO: This is quite simple right now but it should probably be inside its own validation class
  def validate_ingredients_query
    ingredient = params[:ingredient]
    if not ingredient.nil?
      @ingredients = params[:ingredients] || []

      alerts = []
      alerts << t(:cannot_be_blank) if ingredient.blank?
      alerts << t(:cannot_be_sentence) if ingredient.split(" ").size > 1
      alerts << t(:cannot_already_be_submitted) if @ingredients.include?(ingredient)
      alerts << t(:cannot_contain_invalid_characters) if ingredient.include?("&") || ingredient.include?("|")
      flash.alert = alerts.join(" and ") unless alerts.blank?

      render :search and return if flash.alert
    end
  end
end
