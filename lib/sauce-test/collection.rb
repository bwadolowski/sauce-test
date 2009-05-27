require 'yaml'
require 'stringio'
require 'thread'
require 'erb'

require 'sauce-test/runner'

module SauceTest
  module Collection

    class << self
      include ERB::Util

      def run(files, browsers, workers, config, report, type)
        bin_path = File.expand_path(File.dirname(__FILE__) + '/../../bin')
        ENV['PATH'] = bin_path + ':' + ENV['PATH']
        test_array = []
        test_array_mutex = Mutex.new
        @test_result = []
        test_result_mutex = Mutex.new

        Dir.glob(files) do |file|
          sauce_test = 'sauce_test -l -t ' + type.to_s + ' ' + file
          result = `#{sauce_test}`

          groups = YAML::load(StringIO.new result)['groups']

          groups.each do |group|
            group['examples'].each do |example|
              test_array << [file,
                             group['name'],
                             example['name'],
                             example['full_name']]
            end
          end
        end

        browser_threads = []
        worker_threads = []

        browsers.each do |b|
          browser_threads << Thread.new(b) do |browser|
            test_count = 0
            test_count_mutex = Mutex.new
            (1..workers).each do
              worker_threads << Thread.new do
                loop do
                  test = nil
                  test_count_mutex.synchronize do
                    test_array_mutex.synchronize{test = test_array[test_count]}
                    test_count += 1
                  end
                  break unless test

                  file = test[0]
                  group = test[1]
                  example = test[3]
                  report_file = '/' + file + '/' + example + '/' + browser['name'] +
                                '/' + browser['version'].to_s + '/' + browser['os'] + '/report.html'

                  sauce_test = 'sauce_test -t ' + type.to_s + ' ' +
                               '-c ' + config + ' ' +
                               '-r "' + report + report_file + '" ' +
                               '-b ' + browser['name'] + ' ' +
                               '-v ' + browser['version'].to_s + ' ' +
                               '-o "' + browser['os'] + '" ' +
                               '-e "' + example + '" ' + file

                  result = `#{sauce_test}`

                  test_result_mutex.synchronize do
                    example = test[2]
                    status = YAML::load(StringIO.new result)['status']
                    duration = YAML::load(StringIO.new result)['duration']
                    job_id =  YAML::load(StringIO.new result)['groups'][0]['examples'][0]['job_id']
                    @test_result << [file,
                                    group,
                                    example,
                                    browser,
                                    status,
                                    duration,
                                    job_id,
                                    report_file]
                  end
                end
              end
            end
          end
        end

        worker_threads.each{|t| t.join}
        browser_threads.each{|t| t.join}

        template_file = File.dirname(__FILE__) + '/templates/collection_report.erb'
        template_str = IO.readlines(template_file).join
        template = ERB.new(template_str)
        File.new(report + '/report.html', 'w') << template.result(binding)

      end
    end


  end
end
