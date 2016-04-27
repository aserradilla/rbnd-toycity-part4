class Module

  # Creates finder methods using metaprogramming techniques
  def create_finder_methods(*attributes)
    attributes.each do |attribute|
      self.class_eval("
        def self.find_by_#{attribute}(target_value)
          self.all.each do |product|
            if product.#{attribute} == target_value
              return product
            end
          end
        end
      ")
    end
  end
end
