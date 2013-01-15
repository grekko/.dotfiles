# Gregory Igelmund @ Dec 2012
# me@grekko.de

HOME_PATH     = ENV['HOME']
DOTFILES_PATH = "#{HOME_PATH}/.dotfiles"
BACKUPS_PATH  = "#{DOTFILES_PATH}/backups"
BAK_TIME_ID   = Time.now.strftime("%Y-%m-%d-%H%M%S")

DOTFILES = { zsh:
              ['zshrc', 'zshenv', 'zprofile'],
             vim:
              ['vimrc']
}

namespace :setup do
  desc "Installs dotfiles"
  task install: [ :zshconfig, :symlink ] do
    puts "~> sucessfully installed .dotfiles"
  end

  desc "symlink zshrc, zshenv, zprofile"
  task :symlink do
    DOTFILES.each do |path_sym, files|
      dir = path_sym.to_s
      src = "#{DOTFILES_PATH}/#{path}"
      dst = "#{HOME_PATH}/.#{path}"
      if File.exists?(dst)
        puts "~> backing up existing directory #{dst}"
        bak = "#{BACKUPS_PATH}/#{dir}-#{BAK_TIME_ID}"
        FileUtils.mv dst, bak
      end
      FileUtils.ln_s src, dst
      files.each do |file|
        src = "#{DOTFILES_PATH}/#{path}/#{file}"
        dst = "#{HOME_PATH}/.#{file}"
        if File.exists?(dst)
          bak  = "#{BACKUPS_PATH}/#{file}-#{BAK_TIME_ID}"
          puts "~> backing up existing #{dst} -> #{bak}"
          FileUtils.mv dst, bak
        end
        FileUtils.ln_s src, dst
      end
    end
  end

  desc "creates zsh config file"
  task :zshconfig do
    cfgsample = "#{DOTFILES_PATH}/zsh/configs/.sample"
    cfgname = `hostname -s`.chomp
    cfgpath = "#{DOTFILES_PATH}/zsh/configs/#{cfgname}"

    if File.exists?(File.expand_path(cfgpath))
      puts "~> no need to create a config file, since #{cfgpath} already exists"
    else
      FileUtils.cp cfgsample, cfgpath
    end
  end

  desc "remove all backed up rc files"
  task :cleanup do
    FileUtils.remove_entry_secure BACKUPS_PATH, force: true
    FileUtils.mkdir BACKUPS_PATH
    FileUtils.touch "#{BACKUPS_PATH}/.gitkeep"
  end

  desc "show help"
  task :help do
    puts "Use `rake install` to install dotfiles"
  end
end

task default: 'setup:help'
task install: 'setup:install'
task cleanup: 'setup:cleanup'