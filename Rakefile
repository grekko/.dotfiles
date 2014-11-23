# encoding: utf-8
#
# Gregory Igelmund @ Dec 2012
# me@grekko.de
require 'pathname'

HOME_PATH     = Pathname.new(ENV['HOME'])
BASE_PATH     = HOME_PATH + ".dotfiles"
DOTFILES_PATH = BASE_PATH + "dotfiles"
DOTDIRS_PATH  = BASE_PATH + "dotdirs"
BACKUPS_PATH  = DOTFILES_PATH + "backups"
BAK_TIME_ID   = Time.now.strftime("%Y-%m-%d-%H-%M-%S")

module Dotfiles
  module Utils
    module_function
    def safe_symlink(source, target)
      fail "Cannot symlink #{source} since it does not exist" if !File.exists? source

      if File.symlink? target
        puts "removing old symlink: #{target}"
        FileUtils.rm target
      else
        puts "backing up existing file/dir #{target}"
        bak_path = BACKUPS_PATH + "#{File.basename(target)}-#{BAK_TIME_ID}"
        bak_path.mkpath
        puts " \tmoving #{target} -> #{bak_path}"
        FileUtils.mv target, bak_path
      end

      FileUtils.ln_s source, target
      puts "~> creating symlink: #{target} -> #{source}"
    end
  end
end

namespace :setup do

  namespace :symlink do
    task :dotfiles do
      puts "Symlinking dotfiles: #{DOTFILES_PATH}"
      DOTFILES_PATH.children.select { |p| p.file? }.each do |original_file|
        symlink = HOME_PATH + original_file.basename
        Dotfiles::Utils.safe_symlink original_file, symlink
      end
    end

    task :dotdirs do
      puts "Symlinking dotdirs: #{DOTDIRS_PATH}"
      DOTDIRS_PATH.children.select { |p| p.directory? }.each do |original_dir|
        symlink = HOME_PATH + original_dir.basename
        Dotfiles::Utils.safe_symlink original_dir, symlink
      end
    end
  end

  desc "Installs dotfiles"
  task install: ['symlink:dotfiles', 'symlink:dotdirs', :vundle, :scripts]

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

  desc "Install vundle for vim"
  task :vundle do
    target = Pathname.new("~/.vim/bundle/Vundle.vim").expand_path
    next if target.exist?
    sh "git clone https://github.com/gmarik/Vundle.vim.git #{target}"
    puts "Run ':BundleInstall' from within vim to install plugins"
  end

  desc "Install ~/.scripts from github.com/grekko/.scripts"
  task :scripts do
    target = Pathname.new("~/.scripts").expand_path
    next if target.exist?
    sh "git clone https://github.com/grekko/.scripts #{target}"
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
