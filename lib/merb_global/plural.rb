module Merb
  module Global
    module Plural
      ##
      # Returns which form should be returned
      # 
      # @param [Fixnum] n A number of elements
      # @param [String] plural Expression
      #
      # @return [Fixnum] Which form should be translated
      def self.which_form(n, plural)
        eval plural
      end
    end
  end
end
