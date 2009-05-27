require 'yaml'

module SauceTest
  module Helpers

    class SauceTestOptions

      attr_reader :user,
                  :key,
                  :timeout,
                  :browser

      attr_accessor :job_name

      def initialize(browser = nil)
        set_browser(browser || "firefox")
      end

      def parse_config(config_file)
        config = YAML::load_file config_file
        @user = config['login']
        @key = config['key']
        @timeout = config['timeout'] || 180

        if(@user and @key) then true
        else false end
      end

      def browser_json
        %W({ "username": "#{@user}",) +
        %W("access-key": "#{@key}",) +
        %W("job-name": "#{@job_name}",) +
        %W("os": "#{@browser['os']}",) +
        %W("browser": "#{@browser['name']}",) +
        %W("browser-major-version": "#{@browser['version']}" })
      end

      def set_browser_version(version)
        @browser['version'] = version
      end

      def set_os(os)
        @browser['os'] = os
      end

    protected

      def set_browser(name)
        @browser = {}
        case name
          when "firefox", "chrome"
            @browser['name'] = "firefox"
            @browser['version'] = 3
            @browser['os'] = "Linux"
          when "iehta", "iexplore"
            @browser['name'] = "iexplore"
            @browser['version'] = 7
            @browser['os'] = "Windows 2003"
          when "safari"
            @browser['name'] = name
            @browser['version'] = 4
            @browser['os'] = "Windows 2003"
          when "opera"
            @browser['name'] = name
            @browser['version'] = 9
            @browser['os'] = "Windows 2003"
          when "googlechrome"
            @browser['name'] = name
            @browser['version'] = 1
            @browser['os'] = "Windows 2003"
        end
      end

    end

  end
end
