require "rubygems"
require "selenium/client"

module Selenium
  module Client

    class Driver

      def start_new_browser_session(options={})
        sauce_init
        super(options)
        @@last_session_id = @session_id
      end

      def self.set_sauce_options(sauce_options)
        @@sauce_options = sauce_options
      end

      def self.last_session_id
        @@last_session_id
      end

    protected

      def sauce_init
        @host = "saucelabs.com"
        @port = 4444
        @browser_string = @@sauce_options.browser_json
        @default_timeout_in_seconds = @@sauce_options.timeout
      end

    end

  end
end
