class Module
  def create_finder_methods(*attributes)
    # Your code goes here!
    # Hint: Remember attr_reader and class_eval
    attributes.each do |attribute|
      self.send(:define_method, "find_by_#{attribute}=(value)") do
        product_arr = self.all
        attribute = "product" if attribute == "name"
        CSV.foreach(@@data_path, headers: true) do |row|
          if row["#{attribute}"] == value
            return Product.new(id: row["id"], name: row["product"], brand: row["brand"], price: row["price"])
          end
        end
      end
    end
  end
end
