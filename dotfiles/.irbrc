# vim: set filetype=ruby et sw=2 ts=2:
#
# require "utils/irb"
require "irb/completion"

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:AUTO_INDENT]  = true
IRB.conf[:USE_REIDLINE] = true
IRB.conf[:LOAD_MODULES] = [] unless IRB.conf.key?(:LOAD_MODULES)

unless IRB.conf[:LOAD_MODULES].include?("irb/completion")
  IRB.conf[:LOAD_MODULES] << "irb/completion"
end

# Taken from: http://www.samuelmullen.com/2010/04/irb-global-local-irbrc/
def load_irbrc(path)
  return if (path == ENV["HOME"]) || (path == "/")
  load_irbrc(File.dirname path)
  irbrc = File.join(path, ".irbrc")
  puts "loading #{irbrc}"
  load irbrc if File.exists?(irbrc)
end

puts "Loading #{Dir.pwd}"
load_irbrc Dir.pwd
puts ".irbrc loaded!"
