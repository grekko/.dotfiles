%w{rubygems wirble}.each do |lib|
  begin
    require lib
  rescue LoadError => err
    warn "Couldn't load #{lib}: #{err}"
  end
end

# Init Wirble
defined? Wirble and %w{init colorize}.each {|cmd| Wirble.send(cmd)}

# Load additional libs
puts ".irbrc loaded"

IRB.conf[:AUTO_INDENT]  = true
IRB.conf[:USE_READLINE] = true
IRB.conf[:LOAD_MODULES] = [] unless IRB.conf.key?(:LOAD_MODULES)
unless IRB.conf[:LOAD_MODULES].include?('irb/completion')
  IRB.conf[:LOAD_MODULES] << 'irb/completion'
end


# Betterplace stuff
# - check wether being in the betterplace environment
# - load helpers
# skate = Organ
if defined?(Rails) && defined?(Project)
  # use methods instead
  $p = Project[1114]
  $o = Organisation.platform_organisation
  $u = User.where(email: 'gig@betterplace.org').first
  $j = Bettertime::JobDescription.where(carrier_type: 'Collective').last
  $jim = Bettertime::JobDescription.where('carrier_type != "Collective"').last
  puts 'Loaded betterplace helpers'
end
