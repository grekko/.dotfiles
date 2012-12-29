# Need task to:
# - create symlinks for different rc"s like .zshrc, .vimrc
# - add, commit and push updates to remote git repos
# - cleanup (dont know right now for what)

DOTFILES_PATH = '~/.dotfiles'
TIME_ID = Time.now.strftime("%Y-%m-%d-%H%M%S")

namespace :setup do
  desc "Installs dotfiles"
  task install: [ :zshconfig, :symlink ] do
    puts "~> sucessfully installed .dotfiles"
  end

  desc "symlink zshrc, zshenv, zprofile"
  task :symlink do
    ['zshrc', 'zshenv', 'zprofile'].each do |file|
      if File.exists?(File.expand_path("~/.#{file}"))
        puts "~> backing up existing ~/.#{file}"
        sh "mv ~/.#{file} ~/.#{file}-#{TIME_ID}"
      end
      sh "ln -s #{DOTFILES_PATH}/zsh/#{file} ~/.#{file}"
    end
  end

  desc "creates zsh config file"
  task :zshconfig do
    cfgsample = "#{DOTFILES_PATH}/zsh/configs/.sample"
    cfgname = `hostname -s`.chomp
    cfgpath = "#{DOTFILES_PATH}/zsh/configs/#{cfgname}"

    if File.exists?(File.expand_path(cfgpath))
      puts "~> backing up existing config"
      sh "mv #{cfgpath} #{cfgpath}-#{TIME_ID}"
    end
    sh "cp #{cfgsample} #{cfgpath}"
  end

  desc "show help"
  task :help do
    puts "Use `rake install` to install dotfiles"
  end
end

task default: 'setup:help'
task install: 'setup:install'
