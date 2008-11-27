require 'ffi'

module Merb
  module Global
    module NumericProviders
      class Fork
        include Merb::Global::DateProviders::Base
        include FFI::Library

        def localize(lang, number)
          pipe_rd, pipe_wr = IO.pipe
          pid = fork do
            pipe_rd.close
            setlocale(6, lang.to_s)
            pipe_wr.write(number)
            pipe_wr.flush
          end
          pipe_wr.close
          Process.wait(pid)
          pipe_rd.read
        end

        attach_function 'setlocale', [:int, :string], :string
        private :set_locale
      end
    end
  end
end
