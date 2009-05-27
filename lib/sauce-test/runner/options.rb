require 'optparse'

require 'sauce-test/version'
require 'sauce-test/helpers/sauce_test_options'

module SauceTest
  module Runner

    class Options

      attr_reader :list,
                  :test_type,
                  :example,
                  :report_file,
                  :test_file,
                  :sauce_options

      def initialize(opt_array = ARGV)
        @browser = {}

        @opt_parser = OptionParser.new

        @opt_parser.banner = "Usage: sauce_test [options] FILE"

        @opt_parser.on(*OPTIONS[:list])       {|list| @list = true}
        @opt_parser.on(*OPTIONS[:type])       {|type| parse_type type}
        @opt_parser.on(*OPTIONS[:example])    {|example| @example = example}
        @opt_parser.on(*OPTIONS[:report])     {|report| @report_file = File.expand_path report}
        @opt_parser.on(*OPTIONS[:browser])    {|browser| @browser['name'] = browser}
        @opt_parser.on(*OPTIONS[:version])    {|version| @browser['version'] = version}
        @opt_parser.on(*OPTIONS[:os])         {|os| @browser['os'] = os}
        @opt_parser.on(*OPTIONS[:config])     {|config| parse_config(config)}
        @opt_parser.on(*OPTIONS[:help])       {show_help}

        @opt_parser.separator EXAMPLES

        opt_rest = @opt_parser.parse(opt_array)

        create_sauce_options unless list

        parse_test_file(opt_rest[0])
      end

    protected

      def create_sauce_options
        @sauce_options = SauceTest::Helpers::SauceTestOptions.new(@browser['name'])
        parse_config(DEFAULT_CFG) unless @config_file
        show_help unless @sauce_options.parse_config(@config_file)
        @sauce_options.set_os @browser['os'] if @browser['os']
        @sauce_options.set_browser_version @browser['version'] if @browser['version']
      end

      def show_help
        puts SauceTest::VERSION::SUMMARY
        puts @opt_parser
        exit
      end

      def parse_config(path)
        @config_file = File.expand_path path
        show_help unless File.file?(@config_file)
      end

      def parse_test_file(path)
        if path and File.file?(path)
        then @test_file = File.expand_path path
        else show_help end

        unless @test_type
          case File.basename @test_file
            when /_test\.rb/  then @test_type = :unit
            when /_spec\.rb/  then @test_type = :spec
            else show_help
          end
        end
      end

      def parse_type(type_str)
        case type_str
          when 'unit', 'u' then @test_type = :unit
          when 'spec', 's'then @test_type = :spec
          else show_help
        end
      end

      DEFAULT_CFG = './config/sauce.yml'

      OPTIONS = {
        :example => ["-e", "--example NAME", "Run single test case. Use -l to list NAMEs"],
        :list => ["-l", "--list", "List all tests"],
        :type => ["-t", "--type TYPE", "Specify type of test file(optional)",
                                       "spec|s    :RSpec",
                                       "unit|u    :Test::Unit"],
        :report => ["-r", "--report PATH", "HTML report directory path"],
        :config => ["-c", "--config PATH",  "config file path(#{DEFAULT_CFG} by default)"],
        :browser => ["-b", "--browser STRING",  "Sauce Labs JSON web browser string(firefox by default)"],
        :os => ["-o",  "--os STRING", "Sauce Labs JSON operating system string(optional)"],
        :version => ["-v",  "--version NUM",  "Sauce Labs JSON browser version number(optional)"],
        :help => ["-h", "--help", "You're looking at it"]
      }

      EXAMPLES = [ "\nUsage Examples:\n",
                   "    sauce_test example_test.rb",
                   '    sauce_test -r "./reports/" example_spec.rb',
                   "    sauce_test -l example_test.rb",
                   '    sauce_test -b "iexplore" example_test.rb',
                   '    sauce_test -b "firefox" -v 2 -o "Windows 2003" example_spec.rb',
                   '    sauce_test -t unit -e "test_something(ExampleTest)" example_test.rb',
                   '    sauce_test -t s -e "ExampleTest can do something" example_spec.rb']


    end

  end
end
