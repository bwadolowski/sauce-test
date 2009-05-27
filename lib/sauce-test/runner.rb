require 'yaml'
require 'fileutils'

require 'sauce-test/runner/options'
require 'sauce-test/runner/report'
require 'sauce-test/rspec/runner'
require 'sauce-test/testunit/runner'

module SauceTest
  module Runner

    class << self
      def run(opts = nil)
        options = opts || SauceTest::Runner::Options.new

        case options.test_type
          when :unit then runner = SauceTest::TestUnit::Runner
          when :spec then runner = SauceTest::RSpec::Runner
        end

        report = runner.run(options)
        YAML.dump(report.to_hash, $stdout)

        if report_name = options.report_file and !options.list
          FileUtils.mkdir_p File.dirname(report_name)
          File.new(report_name, 'w') << report.to_html
        end
      end
    end

  end
end
