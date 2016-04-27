require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  @@data_path = File.dirname(__FILE__) + "/../data/data.csv"
  create_finder_methods("name","brand","price")

  # Creates a product and adds it to the database if is not already in it
  def self.create(attributes = nil)
    product = Product.new(attributes)
    # If the product is in the database, returns the product
    CSV.foreach(@@data_path, headers: true) do |row|
      if row["id"].to_i == product.id
        return product
      end
    end
    # If the products is not in the database, we insert the product and return the product
    CSV.open(@@data_path, "a+") do |csv|
      csv << [product.id.to_s, attributes[:brand].to_s, attributes[:name].to_s, attributes[:price].to_s]
    end
    return product
  end

  # Returns all the products in the database
  def self.all
    product_arr = []
    CSV.foreach(@@data_path, headers: true) do |row|
      product_arr.push Product.new(id: row["id"], name: row["product"], brand: row["brand"], price: row["price"])
    end
    return product_arr
  end

  # Returns the first n products of the database
  def self.first(number = 1)
    product_arr = self.all
    return number == 1 ? product_arr.first : product_arr.first(number)
  end

  # Returns the last n products of the database
  def self.last(number = 1)
    product_arr = self.all
    return number == 1 ? product_arr.last : product_arr.last(number)
  end

  # Finds a product by its id
  def self.find(id)
    CSV.foreach(@@data_path, headers: true) do |row|
      if row["id"].to_i == id
        return Product.new(id: row["id"], name: row["product"], brand: row["brand"], price: row["price"])
      end
    end
    raise UdacidataErrors::ProductNotFoundError, "There are no products matching '#{id}' id."
  end

  # Removes a product from the database by its id
  def self.destroy(id)
    if id < 0 || id > self.all.length
      raise UdacidataErrors::ProductNotFoundError, "The id '#{id}' is out of boundaries."
    end
    db = CSV.read(@@data_path)
    db.each_with_index do |row, index|
      if row[0].to_i == id
        db.delete_at(index)
        CSV.open(@@data_path, 'wb') do |csv|
          db.each do |row|
            csv << row
          end
        end
        return Product.new(id: row[0], name: row[2], brand: row[1], price: row[3])
      end
    end
  end

  # Returns an array of products matching given brand or name
  def self.where(options = {})
    all_products = self.all
    options.each do |key, value|
      all_products = all_products.select { |product| product.send(key) == value}
    end
    all_products
  end

  # Updates de information for a given product
  def update(options = {})
    new_attributes = {}
    options[:name] ? new_attributes[:name] = options[:name] : new_attributes[:name] = self.name
    options[:brand] ? new_attributes[:brand] = options[:brand] : new_attributes[:brand] = self.brand
    options[:price] ? new_attributes[:price] = options[:price] : new_attributes[:price] = self.price

    Product.destroy(self.id)
    Product.create(new_attributes)
  end
end
