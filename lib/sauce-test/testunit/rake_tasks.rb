module SauceTest
  module Rake

    class TestUnitTask < BaseTask

      def initialize(name = :'sauce:unit')
        @type = :unit
        super(name)
      end

    end

  end
end
