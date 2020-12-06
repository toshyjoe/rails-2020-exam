require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  # https://api.rubyonrails.org/classes/ActionController/Redirecting.html#method-i-redirect_to
  test "creates a product and redirects to products_url" do
    assert_difference('Product.count', 1) do
      post products_url, params: {
        product: {
          title: 'Vaccine',
          price: 42
        }
      }
    end
    assert_redirected_to products_url
  end
end
