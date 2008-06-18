module Merb
  module Global
    module Provider
      # Transfer data from importer into exporter
      #
      # @param [Importer] importer The provider providing the information
      # @param [Exporter] exporter The provider receiving the information
      def self.transfer(importer, exporter)
        exporter.export do |export_data|
          importer.import(exporter, export_data)
        end
      end
      ##
      # Importer is a provider through which one can iterate.
      # Therefore it is possible to import data from this source
      module Importer
        ##
        # This method iterates through the data and calles the export method
        # of exporter
        #
        # @param [Exporter] exporter Exporter to which it should be exported
        # @param export_data Data to pass in calles
        # 
        # @raise NoMethodError Raised by default implementation.
        #                      Should not be thrown.
        def import(exporter, export_data)
          raise NoMethodError.new('method import has not been implemented')
        end
      end

      ##
      # Some sources are not only read-only but one can write to them.
      # The provider is exporter if it handles this sort of source.
      module Exporter
        ##
        # This method handles all transaction stuff that is needed.
        # It also should do a initialization and/or cleanup of all resources
        # needed specificly to the transfer as well as the final
        # flush of changes.
        #
        # @yields exported A data needed for transfer
        def export # Better name needed
          Merb.logger.error('No transaction has been set by exporter')
          yield nil
        end
        ##
        # This method exports a single message. Please note that the calles
        # may be not in any particular order.
        #
        # @param language Language data (yielded by Language call)
        # @param [String] msgid Orginal string
        # @param [String] msgstr  The translation
        # @param [Integer] msgstr_index The number of form
        #                               (nil if only singular)
        def export_string(language, msgid, msgstr, msgstr_index)
          raise NoMethodError.new('method export has not been implemented')
        end
        ##
        # This method export an language. It is guaranteed to be called
        # before any of the messages will be exported.
        #
        # @param export_data Data given from transfer
        # @param [String] language Language call
        # @param [String] plural Format of plural
        #
        # @yield language The data about language
        def export_language(export_data, language, plural)
          raise NoMethodError.new('method export has not been implemented')
        end
      end
    end
  end
end
