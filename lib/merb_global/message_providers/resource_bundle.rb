require 'java'

module Merb
  module Global
    module NumericProviders
      class ResourceBundle
        include Merb::Global::MessageProviders
        
        def localize(singular, plural, n, locale)
          b = bundle(locale)
          unless b.nil?
            pn = Plural.which_form n, b.string('plural')
            b.string("#{singular}.#{pn}")
          else
            n != 1 ? plural : singular
          end
        end

        def create!
          nil
        end

        def bundle(locale)
          base_name = Merb::Global.config([:resource_bundle, :base_name])
          @bundle = java.util.ResourceBundle(base_name, locale.java_locale)
        rescue java.util.MissingResourceException
          nil
        end
          
        private :bundle
      end
    end
  end
end
