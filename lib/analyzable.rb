module Analyzable
  @@data_path = File.dirname(__FILE__) + "/../data/data.csv"

  # Returns the average price of the array passed by argument
  def average_price(product_arr)
    total_price = product_arr.inject(0) { |result, product| result += product.price.to_f }
    return (total_price/product_arr.length).round(2)
  end

  # Returns a report of the database
  def print_report(product_arr)
    report = ""
    report << "Inventory by brand:\n"
    brand_hash = count_by_name(product_arr)
    brand_hash.each do |key, value|
      report << "\t- #{key}: #{value}\n"
    end
    report << "Inventory by name:\n"
    name_hash = count_by_name(product_arr)
    name_hash.each do |key, value|
      report << "\t- #{key}: #{value}\n"
    end
    report << "Average product price: #{average_price(product_arr)}\n"
    return report
  end

  # Reurns a hash of the inventory couts, organized by brand
  def count_by_brand(product_arr)
    brand_hash = {}
    product_arr.each do |product|
      unless brand_hash.include? product.brand
        brand_hash["#{product.brand}"] = 1
      else
        brand_hash["#{product.brand}"] += 1
      end
    end
    return brand_hash
  end

  # Reurns a hash of the inventory couts, organized by name
  def count_by_name(product_arr)
    name_hash = {}
    product_arr.each do |product|
      unless name_hash.include? product.name
        name_hash["#{product.name}"] = 1
      else
        name_hash["#{product.name}"] += 1
      end
    end
    return name_hash
  end
end
