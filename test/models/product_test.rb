require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # https://guides.rubyonrails.org/active_record_validations.html
  test "validates presence of title" do
    product = Product.new(title: ' ')
    refute product.valid?
    assert_includes product.errors.details[:title], error: :blank
  end

  # https://api.rubyonrails.org/classes/ActiveRecord/Relation.html#method-i-update_all
  test ".promote_all! set the promoted attribute to true for all products with the given tag" do
    product_1 = Product.create(title: '1', tags: 'foo', promoted: false)
    product_2 = Product.create(title: '2', tags: 'foo, bar', promoted: false)
    product_3 = Product.create(title: '3', tags: 'bar', promoted: false)

    assert_difference('Product.promoted.size', 2) do
      Product.promote_all!('foo')
    end

    assert product_1.reload.promoted?
    assert product_2.reload.promoted?
    refute product_3.reload.promoted?
  end

  # https://guides.rubyonrails.org/active_record_basics.html#update
  # https://www.omnicalculator.com/finance/discount#how-to-calculate-discount-and-sale-price
  test '#discount! reduces the product price by a percentage' do
    product = Product.create!(title: 'Precious Soap', price: 100)
    assert_equal 100, product.reload.price

    product.discount!(0)
    assert_equal 100, product.reload.price

    product.discount!(40)
    assert_equal 60, product.reload.price

    product.discount!(50)
    assert_equal 30, product.reload.price

    product.discount!(100)
    assert_equal 0, product.reload.price
  end

  # https://guides.rubyonrails.org/active_record_basics.html#update
  test '#discount! appends " 💥" to the product title when discounted by a positive percentage' do
    product = products(:soap)
    product.discount!(80)
    assert_equal 'Soap 💥', product.reload.title

    product = products(:surgical_mask)
    product.discount!(0)
    assert_equal 'Surgical Mask', product.reload.title

    product = products(:homemade_mask)
    product.discount!(1)
    assert_equal 'Homemade Mask 💥', product.reload.title
  end
end
