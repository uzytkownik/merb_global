require 'java'

module Merb
  module Global
    module DateProviders
      class Java
        include Merb::Global::DateProviders::Base
        
        def localize(locale, date, format)
          if date.is_a? Time
            date = [java.util.Date.new(date.to_i*1000)].to_java
          elsif date.respond_to? :to_time
            date = date.to_time
            date = [java.util.Date.new(date.to_i*1000)].to_java
          elsif date.is_a? Date || date.is_a? DateTime
            date = Time.local_time(date.year, date.month, date.day)
            date = [java.util.Date.new(date.to_i*1000)].to_java
          elsif date.respond_to? :to_java
            data = [data.to_java].to_java
          else
            raise "Not yet supported anything else then Time"
          end
          format format.gsub(/%(.)/) do |l|
            if $1 == '%'
              l
            else
              '%t' + $1
            end
          end
          java.lang.String.format(locale.java_locale, format, date)
        end
      end
    end
  end
end
