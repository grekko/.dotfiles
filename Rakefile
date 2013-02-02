# Gregory Igelmund @ Dec 2012
# me@grekko.de

HOME_PATH     = ENV['HOME']
DOTFILES_PATH = "#{HOME_PATH}/.dotfiles"
BACKUPS_PATH  = "#{DOTFILES_PATH}/backups"
BAK_TIME_ID   = Time.now.strftime("%Y-%m-%d-%H%M%S")

DOTFILES = { zsh: ['zshrc', 'zshenv', 'zprofile'],
             vim: ['vimrc']
}

namespace :setup do
  desc "Installs dotfiles"
  task install: [ :zshconfig, :symlink ] do
    puts "~> sucessfully installed .dotfiles"
  end

  desc "symlink zshrc, zshenv, zprofile"
  task :symlink do
    DOTFILES.each do |path_sym, files|
      path = path_sym.to_s
      src_path = "#{DOTFILES_PATH}/#{path}"
      dst_path = "#{HOME_PATH}/.#{path}"

      if File.exists?(dst_path)
        puts "~> backing up existing directory #{dst_path}"
        bak_path = "#{BACKUPS_PATH}/#{path}-#{BAK_TIME_ID}"
        FileUtils.mv dst_path, bak_path
      end
      FileUtils.ln_s src_path, dst_path

      files.each do |file|
        src_file = "#{DOTFILES_PATH}/#{path}/#{file}"
        dst_file = "#{HOME_PATH}/.#{file}"
        if File.exists?(dst_file)
          bak_file  = "#{BACKUPS_PATH}/#{file}-#{BAK_TIME_ID}"
          puts "~> backing up existing #{dst_file} -> #{bak_file}"
          FileUtils.mv dst_file, bak_file
        end
        FileUtils.ln_s src_file, dst_file
      end

    end
  end

  desc "creates zsh config file"
  task :zshconfig do
    cfg_sample = "#{DOTFILES_PATH}/zsh/configs/.sample"
    cfg_name = `hostname -s`.chomp
    cfg_path = "#{DOTFILES_PATH}/zsh/configs/#{cfg_name}"

    if File.exists?(File.expand_path(cfg_path))
      puts "~> no need to create a config file, since #{cfg_path} already exists"
    else
      FileUtils.cp cfg_sample, cfg_path
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
