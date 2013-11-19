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
# Ruby 1.8 syntax since old ruby versions may load this file
if defined?(Rails) && defined?(Project)
  def p; Project[1114]; end
  def bet; Organisation.platform_organisation; end
  def me; User.where(:email => 'gig@betterplace.org').first; end
  def tobi; User.where(:email => 'tjo@betterplace.org').first; end
  def mjo; User.where(:email => 'mjo@betterplace.org').first; end
  def job; Bettertime::JobDescription.where(:carrier_type => 'Collective').last; end
  def job_am; Bettertime::JobDescription.where('carrier_type != "Collective"').last; end
  FC = FundraisingChallenge
  puts 'Loaded betterplace helpers'
end
