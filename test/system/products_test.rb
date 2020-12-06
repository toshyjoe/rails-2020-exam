require 'application_system_test_case'

class ProductsTest < ApplicationSystemTestCase
  def product_titles
    all('tbody td.title').map(&:text)
  end

  def product_prices
    all('tbody td.price').map(&:text).map(&:to_i)
  end

  test 'products index list is ordered by price' do
    Product.create!(title: 'Most expensive product', price: 42)

    visit products_url

    assert_selector 'h1', text: 'Products'
    assert_equal [
      'Most expensive product',
      'Hydroalcoholic gel',
      'Homemade Mask',
      'N95 Mask',
      'Soap',
      'Surgical Mask'
    ], product_titles
    assert_equal [42, 10, 5, 3, 2, 1], product_prices
    assert_current_path '/products'
  end

  test 'filters all promoted products with special /promo route' do
    Product.create!(title: 'New promoted product', promoted: true)

    visit products_url

    assert_selector 'h1', text: 'Products'
    assert_equal [
      'Homemade Mask',
      'Hydroalcoholic gel',
      'N95 Mask',
      'New promoted product',
      'Soap',
      'Surgical Mask'
    ], product_titles.sort
    assert_current_path '/products'

    click_on 'Promoted Products'

    assert_selector 'h1', text: 'Products'
    assert_equal [
      'Homemade Mask',
      'Hydroalcoholic gel',
      'New promoted product'
    ], product_titles.sort
    assert_current_path '/promo'
  end

  test "creating a new product" do
    visit products_url

    assert_selector 'h1', text: 'Products'

    click_on 'New Product'

    fill_in 'Title', with: 'New product'
    fill_in 'Price', with: '42'
    fill_in 'Tags', with: 'foo'
    click_on 'Create Product'

    assert_text 'Product was successfully created'

    visit products_url

    assert_selector 'h1', text: 'Products'
    assert_includes product_titles, 'New product'
    assert_includes product_prices, 42
    assert_current_path '/products'
  end

  test "promotes and demotes a product from its page" do
    product = products(:soap)

    visit product_url(product)

    assert_text 'Title: Soap'
    assert_text 'Promoted: false'

    click_on "Promote!"

    assert_text 'Title: Soap'
    assert_text 'Promoted: true'
    assert product.reload.promoted?

    click_on "Demote!"

    assert_text 'Title: Soap'
    assert_text 'Promoted: false'
    refute product.reload.promoted?
  end

  # Keep that one for the end!
  test 'filters all products by tag with special /tagged/:tag route' do
    Product.create!(title: 'Premium Soap', tags: 'hand')

    visit products_url

    assert_selector 'h1', text: 'Products'
    assert_equal [
      'Homemade Mask',
      'Hydroalcoholic gel',
      'N95 Mask',
      'Premium Soap',
      'Soap',
      'Surgical Mask'
    ], product_titles.sort
    assert_current_path '/products'

    click_on 'Hand Products'

    assert_selector 'h1', text: 'Products'
    assert_equal [
      'Hydroalcoholic gel',
      'Premium Soap',
      'Soap'
    ], product_titles.sort
    assert_current_path '/tagged/hand'

    click_on 'Mask Products'

    assert_selector 'h1', text: 'Products'
    assert_equal [
      'Homemade Mask',
      'N95 Mask',
      'Surgical Mask'
    ], product_titles.sort
    assert_current_path '/tagged/mask'
  end
end
