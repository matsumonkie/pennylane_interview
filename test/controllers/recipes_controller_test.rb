require 'test_helper'

class RecipesControllerTest < ActionDispatch::IntegrationTest
  test "should get search page" do
    get recipes_search_url
    assert_response :success
  end

  test "should search recipes by ingredients" do
    recipe1 = Recipe.create(name: "Recipe 1", ingredients: ["pomme", "banane"])
    recipe2 = Recipe.create(name: "Recipe 2", ingredients: ["chocolat", "banane"])

    get recipes_search_url(ingredient: "banane")
    assert_response :success

    # Make sure we display the list of submitted ingredients
    assert_select "ul#ingredients-list" do
      assert_select "li", 1
      assert_select "li" do |elements|
        assert elements.to_s.include?("banane")
      end
    end

    # Make sure we display the list of recipe
    assert_select "ul#recipes-list" do
      assert_select "li", 2
      assert_select "li" do |elements|
        assert elements.to_s.include?("Recipe 1")
        assert elements.to_s.include?("Recipe 2")
      end
    end
  end

  test "should handle no matching recipes" do
    recipe1 = Recipe.create(name: "Recipe 1", ingredients: ["pomme", "poire"])

    get recipes_search_url(ingredient: "chocolat")
    assert_response :success

    assert_select "h2", "No Matching Recipes"
  end

  test "should display flash alert on invalid request" do
    get recipes_search_url(ingredient: "foo bar")
    assert_select "div#alert", text: I18n.t(:cannot_be_sentence)

    get recipes_search_url(ingredient: "&")
    assert_select "div#alert", text: I18n.t(:cannot_contain_invalid_characters)

    get recipes_search_url(ingredient: "")
    assert_select "div#alert", text: I18n.t(:cannot_be_blank)

    get recipes_search_url(ingredient: "foo &")
    assert_select "div#alert", text: "#{I18n.t(:cannot_be_sentence)} and #{I18n.t(:cannot_contain_invalid_characters)}"
  end
end
