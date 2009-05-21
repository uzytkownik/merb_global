require 'java'

module Merb
  module Global
    module DateProviders
      class Java
        include Merb::Global::DateProviders::Base
        
        def localize(locale, date, format)
          if date.is_a? Time
            date = [java.util.Date.new(date.to_i)].to_java
            format format.gsub(/%(.)/) do |l|
              if $1 == '%'
                l
              else
                '%t' + $1
              end
            end
            java.lang.String.format(locale.java_locale, format, date)
          else
            raise "Not yet supported anything else then Time"
          end
        end
      end
    end
  end
end
