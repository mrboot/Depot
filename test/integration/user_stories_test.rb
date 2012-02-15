require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products

test "buying a product" do
    # Delete all the line_items and orders and get the :ruby product from the fixture into a variable
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)

    # User story step 1: A user goes to the store index page.
    get "/"
    assert_response :success 
    assert_template "index"
  
    # User story step 2: They select a product, adding it to their cart.
    # we use AJAX to add to the cart so need to use xml_http_request here
    xml_http_request :post, '/line_items', product_id: ruby_book.id 
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    # User story step 3: They then check out..
    get "/orders/new" 
    assert_response :success 
    assert_template "new"

    # User story step 4: The user fills out their details and clicks order
    post_via_redirect "/orders",
    order: {  name: "Dave Thomas",
              address: "123 The Street", 
              email: "dave@example.com", 
              payment_type_id: 1 }
            
    assert_response :success 
    assert_template "index"
    cart = Cart.find(session[:cart_id]) 
    assert_equal 0, cart.line_items.size

    # User story step 5: an order is created in the database
    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]
  
    assert_equal "Dave Thomas", order.name 
    assert_equal "123 The Street", order.address 
    assert_equal "dave@example.com", order.email 
    assert_equal 1, order.payment_type_id
  
    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product

    # User story step 6: A mail is sent confirming the order
    mail = ActionMailer::Base.deliveries.last
    assert_equal ["dave@example.com"], mail.to
    assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value 
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
    
  end
end
