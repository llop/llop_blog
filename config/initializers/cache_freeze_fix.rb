if Rails.env.test?
  puts 'start'
  ActiveRecord::Base.class_eval do
    def dup
      puts 'heh'
      obj = super
      obj.instance_variable_set('@attributes', instance_variable_get('@attributes').dup)
      obj
    end
  end
  ActiveSupport::Cache::FileStore.class_eval do
    def read(name, options = nil)
      puts 'out'
      super
      @data[name].duplicable? ? @data[name].dup : @data[name]
    end
    def write(name, value, options = nil)
      puts 'in'
      super
      @data[name] = (value.duplicable? ? value.dup : value).freeze
    end
  end
end