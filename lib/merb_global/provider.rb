module Merb
  module Global
    # Merb-global is able to store the translations in different types of
    # storage. An interface betwean merb-global and those storages are
    # providers.
    # 
    # Please note that it is not required to include this module - despite it
    # is recomended both as a documentation part and the more customized 
    # error messages.
    module Provider
      # Translate string using specific provider.
      # It should be overloaded by the implementator.
      #
      # Do not use this method directly - use Merb::Global._ instead
      #
      # @param [String] singular A string to translate
      # @param [String] plural A plural form of string (nil if only singular)
      #
      # @opt [String] lang A language to translate on
      # @opt [Fixnum] n A number of objects
      #
      # @return [String] A translated string
      #
      # @raise NoMethodError Raised by default implementation.
      #                      Should not be thrown.
      def translate_to(singular, plural, opts)
        raise NoMethodError.new('method translate_to has not been implemented')
      end

      ##
      #
      # Checks if the language is supported (i.e. if the translation exists).
      #
      # In normal merb app the language is checked automatically in controller
      # so probably you don't have to use this method
      #
      # @param [String] lang A code of language
      #
      # @return [Boolean] Is a program translated to this language
      #
      # @raise NoMethodError Raised by default implementation.
      #                      Should not be thrown.
      def support?(lang)
        raise NoMethodError.new('method support? has not been implemented')
      end

      ##
      # This method creates basic files and/or directory structures
      # (for example it adds migration) needed for provider to work.
      #
      # It is called from Rakefile.
      #
      # @raise NoMethodError Raised by default implementation.
      #                      Should not be thrown.
      def create!
        raise NoMethodError.new('method create! has not been implemented')
      end
      
      # This method choos an supported language except those form the list
      # given. It may fallback to english if none language can be found
      # which agree with those criteria.
      #
      # @raise NoMethodError Raised by default implementation.
      #                      Should not be thrown.
      def choose(except)
        raise NoMethodError.new('method choose has not been implemented')
      end
    end
  end
end
