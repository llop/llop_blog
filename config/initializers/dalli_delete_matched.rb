if Rails.env.production?
  ActiveSupport::Cache::DalliStore.class_eval do
    
    MEM_CACHED_KEYS = "memcached_keys"
    
    alias_method :old_write_entry, :write_entry
    def write_entry(key, entry, options)
      keys = get_keys
      unless keys.include?(key)
        keys << key
        return false unless old_write_entry(MEM_CACHED_KEYS, keys.to_yaml, options)
      end
      old_write_entry(key, entry, options)
    end
    
    alias_method :old_delete_entry, :delete_entry
    def delete_entry(key, options)
      ret = old_delete_entry(key, options)
      return false unless ret
      keys = get_keys
      if keys.include?(key)
        keys -= [ key ]
        old_write_entry(MEM_CACHED_KEYS, keys.to_yaml, options)
      end
      ret
    end
    
    def delete_matched(matcher, options = nil)
      loop = true
      deleted_keys = []
      keys = get_keys
      keys.each do |key|
        puts ('key name ' + key)
        if loop && key.match(matcher)
          loop = old_delete_entry(key, options)
          deleted_keys << key
        end
      end
      if loop
        len = keys.length
        keys -= deleted_keys
        old_write_entry(MEM_CACHED_KEYS, keys.to_yaml, options || []) if keys.length < len
      end
      loop
    end
  
  private
    def get_keys
      begin
        YAML.load read(MEM_CACHED_KEYS)
      rescue TypeError
        [ MEM_CACHED_KEYS ]
      end
    end
    
  end
end