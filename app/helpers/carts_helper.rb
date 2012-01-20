module CartsHelper
  
  def total_price(line_item_id)
    item = @cart.line_items.find(line_item_id)
    total_price = item.product.price * item.quantity    
  end
  
end
