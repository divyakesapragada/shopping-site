require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  fixtures :products

  test 'product attributes must not be empty' do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end

  test 'price must be positive' do
    product = Product.new(title: 'My Book Title',
                          description: 'abcxyz',
                          image_url: '123.jpg')
    product.price = -1
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

    product.price = 5
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(title: 'My Book Title',
                description: 'abcxyz',
                price: 5,
                image_url: image_url)
  end

  test 'image url' do
    good = %w{ divi.jpg divi.gif divi.png divi.JPG divi.GIF divi.PNG http://www.google.com/divi.jpg }
    bad = %w{ divi.doc divi.xls diviabcxyz }
    good.each do |name|
      assert new_product(name).valid?, "#{name} should be valid"
    end
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test 'product is not valid without a unique title' do
    product = Product.new(title: products(:ruby).title,
                          description: 'abcxyz',
                          image_url: '123.jpg',
                          price: 5)
    assert product.invalid?
    assert_equal ['has already been taken'], product.errors[:title]
  end

end
