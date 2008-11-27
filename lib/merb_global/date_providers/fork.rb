require 'ffi'

module Merb
  module Global
    module DateProviders
      class Fork
        include Merb::Global::DateProviders::Base
        include FFI::Library

        def localize(lang, date, format)
          pipe_rd, pipe_wr = IO.pipe
          pid = fork do
            pipe_rd.close
            setlocale(6, lang.to_s) # LC_ALL
            pipe_wr.write(date.strftime(format))
            pipe_wr.flush
          end
          pipe_wr.close
          Process.wait(pid)
          pipe_rd.read
        end

        attach_function 'setlocale', [:int, :string], :string
        private :setlocale
      end
    end
  end
end
