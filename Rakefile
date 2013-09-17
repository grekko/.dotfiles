# encoding: utf-8
#
# Gregory Igelmund @ Dec 2012
# me@grekko.de

HOME_PATH     = ENV['HOME']
DOTFILES_PATH = "#{HOME_PATH}/.dotfiles"
BACKUPS_PATH  = "#{DOTFILES_PATH}/backups"
BAK_TIME_ID   = Time.now.strftime("%Y-%m-%d-%H-%M-%S")

namespace :setup do
  desc "Installs dotfiles"
  task install: [ :symlink ] do
    puts "~> sucessfully installed .dotfiles"
  end

  desc "symlink dotfiles"
  task :symlink do
    puts "Working in #{DOTFILES_PATH}"
    dotfiles = Dir.glob("#{DOTFILES_PATH}/dotfiles/*", File::FNM_DOTMATCH).reject {|f| File.basename(f) == '.' || File.basename(f) == '..' }
    dotfiles.each do |path|
      file = File.basename(path)
      dst_path = "#{HOME_PATH}/#{file}"

      if File.exists? dst_path
        if File.symlink? dst_path
          puts "removing old symlink: #{dst_path}"
          FileUtils.rm dst_path
        else
          puts "backing up existing file/dir #{dst_path}"
          bak_path = "#{BACKUPS_PATH}/#{file}-#{BAK_TIME_ID}"
          puts " \tmoving #{dst_path} -> #{bak_path}"
          FileUtils.mv dst_path, bak_path
        end
      end

      FileUtils.ln_s path, dst_path
      puts "~> creating symlink: #{path} -> #{dst_path}"
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
