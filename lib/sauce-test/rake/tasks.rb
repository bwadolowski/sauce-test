require 'sauce-test/collection'

module SauceTest
  module Rake

    class BaseTask

      attr_accessor :files, :browsers, :report, :workers, :config

      def initialize(name)
        @name = name
        @browsers = [{'os' => "Linux", 'name' => "firefox", 'version' => 3},
                     {'os' => "Windows 2003", 'name' => "iexplore", 'version' => 7}]
        @workers = 1
        @config = 'config/sauce.yml'
        @report = 'reports/sauce_test'

        yield self if block_given?

        define_task
      end

      def define_task
        task @name do
          SauceTest::Collection.run(@files, @browsers, @workers, @config, @report, @type)
        end
      end

    end

  end
end

require 'sauce-test/rspec/rake_tasks'
require 'sauce-test/testunit/rake_tasks'
