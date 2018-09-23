class RecipesController < ApplicationController
  def index
  	@search_item = params[:search] || 'chocolate' 	
  	@searches = Recipe.for(@search_item)
  end
end
