class Recipe < ApplicationRecord
  before_save :set_text_search

  LOCALE = 'french'

  scope :with_ingredients, ->(ingredients) {
    if ingredients.present?
      where("text_search @@ to_tsquery('#{LOCALE}', ?)", ingredients.join(' & '))
    else
      []
    end
  }

  private

  # Every time we update the recipe model, we need to reconstruct the tsvector
  # so that we can full text search the ingredients
  def set_text_search
    query = ActiveRecord::Base.sanitize_sql_array(["SELECT to_tsvector('#{LOCALE}', ?)", ingredients.join(' ')])
    self.text_search = ActiveRecord::Base.connection.execute(query).first['to_tsvector']
  end
end
