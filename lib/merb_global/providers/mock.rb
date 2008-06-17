module Merb
  module Global
    module Providers
      class Mock #:nodoc:
        include Merb::Global::Provider
        
        def translate_to(singular, plural, opts)
          opts[:n] > 1 ? plural : singular
        end

        def support?(lang)
          true
        end

        def create!
          nil # It's mock after all ;)
        end

        def choose
          'en'
        end
      end
    end
  end
end
