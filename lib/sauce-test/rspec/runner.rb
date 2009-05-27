require 'stringio'

require 'rubygems'
require 'spec'

require 'sauce-test/rspec/sauce_formatter'
require 'sauce-test/selenium/client_driver_extension'

module SauceTest
  module RSpec

    module Runner

      class << self
        def run(options)
          @options = options
          rspec_init
          Spec::Runner.run
          report = SauceTest::RSpec::Runner::SauceFormatter.report
          report.test_file = @options.test_file
          report
        end

        def rspec_init
          out_str = StringIO.new
          err_str = StringIO.new
          spec_opt = Spec::Runner::Options.new(@err_str, @out_str)

          if @options.list
            spec_opt.dry_run = true
          else
            SauceTest::RSpec::Runner::SauceFormatter.set_sauce_test_options @options.sauce_options
          end

          if @options.example
            spec_opt.parse_example @options.example
          end

          spec_opt.parse_format SauceTest::RSpec::Runner::SauceFormatter.to_s
          spec_opt.files << @options.test_file

          Spec::Runner.use spec_opt
        end
      end

    end

  end
end
