# vim: set filetype=ruby et sw=2 ts=2:
#
# require "utils/irb"
require 'irb/completion'

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:AUTO_INDENT]  = true
IRB.conf[:USE_MULTILINE] = true
IRB.conf[:LOAD_MODULES] = [] unless IRB.conf.key?(:LOAD_MODULES)

IRB.conf[:LOAD_MODULES] << 'irb/completion' unless IRB.conf[:LOAD_MODULES].include?('irb/completion')

def measure_memory
  if block_given?
    time_before = Time.current
    mem_before = `ps -o rss= -p #{$$}`.to_i
    yield
    time_after = Time.current
    mem_after = `ps -o rss= -p #{$$}`.to_i
    puts '================='
    puts "Executed in #{time_after - time_before}s"
    puts '================='
    puts 'Memory usage ===='
    puts "before: #{mem_before} Bytes"
    puts "after: #{mem_after} Bytes"
    puts "=> #{mem_after - mem_before} Bytes"
    puts '================='
  end
end
