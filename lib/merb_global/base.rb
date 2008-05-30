require 'merb_global/config'
require 'merb_global/plural'
require 'merb_global/provider'
require 'merb_global/providers'

module Merb
  module Global
    attr_accessor :lang, :provider
    def lang #:nodoc:
      @lang ||= "en"
    end
    def provider #:nodoc:
      @provider ||= Merb::Global::Providers.provider
    end
    ##
    #
    # Translate a string
    # @param [String] singular A string to translate
    # @param [String] plural A plural form of string
    # @param [Hash] opts An options hash (see below)
    # @return [String] A translated string
    # @opt [String] lang A language to translate on
    # @opt [Fixnum] n A number of objects
    #
    # ==== Example
    # <tt>render _("%d file deleted", "%d files deleted", :n => del) % del</tt>
    def _(*args)
      opts = {:lang => self.lang, :n => 1}
      opts.merge! args.pop if args.last.is_a? Hash
      if args.size == 1
        self.provider.translate_to args[0], nil, opts
      elsif args.size == 2
        self.provider.translate_to args[0], args[1], opts
      else
        raise ArgumentError, "wrong number of arguments (#{args.size} for 1-2)"
      end
    end
  end
end
