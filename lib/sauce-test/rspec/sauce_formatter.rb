require 'spec/runner/formatter/base_formatter'

module SauceTest
  module RSpec
    module Runner

      class SauceFormatter < Spec::Runner::Formatter::BaseFormatter

        def initialize(options, output)
          @dry_run = !!options.dry_run
          @selenium = Selenium::Client::Driver
          @selenium.set_sauce_options(@@sauce_options) unless @dry_run
          @@report = SauceTest::Runner::Report.new
          @@report.browser = @@sauce_options.browser unless @dry_run
        end

        def example_group_started(group_proxy)
          @group = group_proxy.description
        end

        def example_started(example_proxy)
          example = example_proxy.description
          if @dry_run
            @@report.add_example(@group,
                                 {'name' => example,
                                  'status' => 'passed'})
          else
            @@sauce_options.job_name = @group + ' ' + example unless @dry_run
          end
        end

        def example_pending(example_proxy, message)
          @@report.add_example(@group,
                               {'name' => example_proxy.description,
                                'status' => 'pending',
                                'message' => message})
        end

        def example_passed(example_proxy)
          @@report.add_example(@group,
                               {'name' => example_proxy.description,
                                'status' => 'passed',
                                'job_id' => @selenium.last_session_id }
                              ) unless @dry_run
        end

        def example_failed(example_proxy, counter, failure)
          failure.exception.backtrace[0] =~ /(.*):(\d+)/
          file = $1
          line = $2.to_i
          @@report.add_example(@group,
                               {'name' => example_proxy.description,
                                'status' => 'failed',
                                'job_id' => @selenium.last_session_id,
                                'message' => failure.exception.message,
                                'file' => file,
                                'line' => line})
        end

        def dump_summary(duration, example_count, failure_count, pending_count)
          @@report.duration = duration
        end

        def self.report
          @@report
        end

        def self.set_sauce_test_options(options)
          @@sauce_options = options.clone
        end

      end

    end
  end
end
