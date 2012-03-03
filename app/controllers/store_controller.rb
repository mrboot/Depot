class StoreController < ApplicationController
  
  skip_before_filter :authorize
  
  def index
    @products = Product.order(:title)
    @cart = current_cart
    
    increment_count
    
    @show_counter = session[:counter] >=5
    
  end

  private
  
  def increment_count
    session[:counter] ||= 0
    session[:counter] += 1   
  end

end
