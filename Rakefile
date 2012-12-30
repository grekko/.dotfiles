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
    { zsh:
        ['zshrc', 'zshenv', 'zprofile'],
      vim:
        ['vimrc']
    }.each do |path, files|
      path_abs = File.expand_path("~/.#{path}")
      if File.exists?(path_abs)
        puts "~> backing up existing directory #{path_abs}"
        sh "mv #{path_abs} #{path_abs}-#{TIME_ID}"
      end
      sh "ln -s #{DOTFILES_PATH}/#{path} #{path_abs}"
      files.each do |file|
        filepath_abs = File.expand_path("~/.#{file}")
        if File.exists?(filepath_abs)
          puts "~> backing up existing #{filepath_abs}"
          sh "mv #{filepath_abs} #{filepath_abs}-#{TIME_ID}"
        end
        sh "ln -s #{DOTFILES_PATH}/#{path}/#{file} #{filepath_abs}"
      end
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
