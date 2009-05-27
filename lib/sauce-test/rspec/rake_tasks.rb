module SauceTest
  module Rake

    class RSpecTask < BaseTask

      def initialize(name = :'sauce:spec')
        @type = :spec
        super(name)
      end

    end

  end
end
