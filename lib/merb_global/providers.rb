module Merb
  module Global
    module Providers
      ##
      #
      # Returns the directory where locales are stored for file-backended
      # providers (such as gettext or yaml)
      #
      # @returns [String] localedir Directory where the locales are stored
      def self.localedir
        localedir =
          if Merb::Global.config :flat
            'locale'
          else
            Merb::Global.config :localedir, File.join('app', 'locale')
          end
        File.join Merb.root, localedir
      end
      # Is there a way to mark static methods as private?
      @@provider_name = lambda do 
        Merb::Global.config :provider, 'gettext'
      end
      @@provider_loading = lambda do |provider|
        # Should it be like that or should the provider be renamed?
        require 'merb_global/providers/' + provider
        @@provider = eval "Merb::Global::Providers::#{provider.camel_case}.new"
      end
      ##
      #
      # Returns the provider of required type
      #
      # @returns [Provider] provider Returns provider
      def self.provider
        @@provider ||= @@provider_loading.call @@provider_name.call
      end
    end
  end
end
