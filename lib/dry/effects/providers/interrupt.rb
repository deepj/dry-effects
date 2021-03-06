require 'dry/effects/provider'

module Dry
  module Effects
    module Providers
      class Interrupt < Provider
        attr_reader :signal

        def initializer(*)
          super
          @signal = :"effect_interrupt_interrupt_#{identifier}"
        end

        def interrupt(*payload)
          throw signal, payload
        end

        def call
          caught = true
          result = catch(signal) do
            result = yield
            caught = false
            result
          end

          if caught
            result[0]
          else
            result
          end
        end
      end
    end
  end
end
