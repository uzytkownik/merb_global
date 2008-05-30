module Merb
  module Global
    ##
    #
    # Lookup the configuration
    #
    # @param [Symbol] key A key
    # @param [Array<Symbol>] keys Keys
    # @param default A default value
    #
    # @return Object read from configuration or default
    #
    # ==== Examples
    # <tt>Merb::Global.config [:gettext, :domain], 'merbapp'</tt>
    def self.config(keys, default = nil)
      keys = [keys] unless keys.is_a? Array
      current = Merb::Plugins.config[:merb_global]
      while current.respond_to?(:[]) and not keys.empty?
        current = current[keys.shift]
      end
      (keys.empty? and not current.nil?) ? current : default
    end
  end
end
