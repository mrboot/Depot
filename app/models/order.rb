# == Schema Information
#
# Table name: orders
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  address         :text
#  email           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  payment_type_id :integer
#

class Order < ActiveRecord::Base
  
  # PAYMENT_TYPES = [ "Check", "Credit card", "Purchase order" ]  # This constant has to go first to be valid

  validates :name, :address ,:email, presence: true
  validates :payment_type_id, presence: true 
  # validates :pay_type, inclusion: PAYMENT_TYPES
  
  has_many :line_items, dependent: :destroy
  belongs_to :payment_type
  
  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
  
end
