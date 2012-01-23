class AddPriceToLineItems < ActiveRecord::Migration
  def up
    add_column :line_items, :product_price, :decimal, precision: 8, scale: 2
    
    LineItem.all.each do |item|
      item.product_price = item.product.price
      item.save!
    end
  end
  
  def down
    remove_column :line_items, :product_price
  end
  
end
