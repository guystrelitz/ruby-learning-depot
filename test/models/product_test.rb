require 'test_helper'

class ProductTest < ActiveSupport::TestCase
	fixtures :products

	test 'product attributes must not be empty' do
		product = Product.new
		assert product.invalid?
		assert product.errors[:title].any?
		assert product.errors[:description].any?
		assert product.errors[:price].any?
		assert product.errors[:image_url].any?
	end

	test 'product price must be positive' do
		product = Product.new(title: 'title', description: '0123456789', image_url: 'aaa.jpg')

		product.price = -1
		assert product.invalid?
		assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

		product.price = -0
		assert product.invalid?
		assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

		product.price = 1
		assert product.valid?
	end

	def new_product(image_url)
		Product.new(title: 'product for image url', description: '0123456789', price: 1, image_url: image_url)
	end

	test 'image_url' do
		ok = %w{ fred.gif fred.jpg fred.png FRED.GIF FRED.Jpg http://a.b.c/x/y/z/fred.gif }
		ok.each { |image_url| assert new_product(image_url).valid?, "#{image_url} should be valid" }

		bad = %w{ fred.doc fred.gif.more fred.gif/more }
		bad.each { |image_url| assert new_product(image_url).invalid?, "#{image_url} should be invalid" }
	end

	test 'product is not valid without a unique title' do
		product = Product.new(
			title: products(:ruby).title,
			description: 'yyy',
			price: 1,
			image_url: 'fred.gif')
		assert product.invalid?
		assert_equal ['has already been taken'], product.errors[:title]
	end

	test 'product is not valid without a unique title - i18n' do
		product = Product.new(
			title: products(:ruby).title,
			description: 'yyy',
			price: 1,
			image_url: 'fred.gif')
		assert product.invalid?
		assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
	end

	test 'product description must be >= 10 characters' do
		product = Product.new(
			title: 'book with short description',
			description: 'yyy',
			price: 1,
			image_url: 'fred.gif')
		assert product.invalid?, 'expected short description to be invalid'
		assert_equal ['must be at least 10 characters long.'], product.errors[:description]
	end

end
