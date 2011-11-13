if Rails.env.production?
  ActiveSupport::Cache::DalliStore.class_eval do
              
    def write(name, value, options = nil)
      super
      key_list = get_key_list
      unless key_list.include?(name)
        key_list << name
        return false unless _write("memcached_store_key_list", key_list.to_yaml, options)
      end
      _write(name, value, options)
    end
        
    def delete_type(type, options = nil)
      type = type.to_s if type.is_a?(Symbol)
      matcher = Regexp.new("^#{type}")
      keys_to_remove = []
      key_list = get_key_list
      key_list.each do |key|
        if key.match(matcher)
          # puts "key matched!: #{key.inspect}"
          return false unless delete(key, options)
          keys_to_remove << key
        end
      end
      key_list -= keys_to_remove
      _write("memcached_store_key_list", key_list.to_yaml, options)
    end
  
  private
  
    def get_key_list
      begin
        YAML.load(read('memcached_store_key_list'))
      rescue TypeError
        []
      end
    end
  
    def _write(key, value, options = nil)
      method = options && options[:unless_exist] ? :add : :set
      response = @data.send(method, key, value, expires_in(options), raw?(options))
      return true if response.nil?
      response == Response::STORED
    rescue Dalli::DalliError => e
      logger.error("DalliError (#{e}): #{e.message}")
      false
    end
    
  end
end