require 'erb'

module SauceTest
  module Runner

    class Report

      include ERB::Util

      attr_accessor :test_file, :browser, :duration

      def initialize
        @groups = []
        @status = 'passed'
        @count = {'total' => 0,
                  'pending' => 0,
                  'failed' => 0}
      end

      def add_example(group_name, descripton)
        descripton['full_name'] = group_name + ' ' + descripton['name']
        @count['total'] += 1
        status = descripton['status']
        @count['pending'] += 1 if status == 'pending'
        @count['failed'] += 1 if status == 'failed'

        group = nil
        @groups.each do |g|
          if g['name'] == group_name
            group = g
            g['examples'] << descripton
            g['status'] = status if status != 'passed' and g['status'] != 'failed'
          end
        end

        unless group
          group = {'name' => group_name,
                   'status' => status,
                   'examples' => [descripton]}
          @groups << group
        end

        @status = status if status != 'passed' and @status != 'failed'
      end

      def to_hash
        {'file' => test_file,
          'browser' => browser,
          'duration' => duration,
          'status' => @status,
          'count' => @count,
          'groups' => @groups}
      end

      def to_html
        template_file = File.dirname(__FILE__) + '/../templates/test_report.erb'
        template_str = IO.readlines(template_file).join
        template = ERB.new(template_str)
        template.result(binding)
      end

    end

  end
end
