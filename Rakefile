# encoding: utf-8
#
# Gregory Igelmund
# me@grekko.de
#
require 'pathname'

HOSTNAME              = `hostname -s`.chomp
HOME_PATH             = Pathname.new(ENV.fetch('HOME'))
BASE_PATH             = HOME_PATH + ".dotfiles"
DOTFILES_BASE_PATH    = BASE_PATH + "dotfiles"
DOTFILES_MACHINE_PATH = BASE_PATH + "dotfiles/machines/#{HOSTNAME}"
DOTDIRS_PATH          = BASE_PATH + "dotdirs"
VIM_PATH              = HOME_PATH + ".vim"
BACKUPS_PATH          = DOTFILES_BASE_PATH + "backups"
BAK_TIME_ID           = Time.now.strftime("%Y-%m-%d-%H-%M-%S")

module Dotfiles
  module Utils
    module_function
    def safe_symlink(source, target)
      fail "Cannot symlink #{source} since it does not exist" if !File.exists? source

      if File.symlink? target
        puts "removing old symlink: #{target}"
        FileUtils.rm target
      elsif File.exists? target
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
    task dotfiles: %w[dotfiles_base dotfiles_for_machine]

    task :dotfiles_base do
      puts "Symlinking base dotfiles for all machines: #{DOTFILES_BASE_PATH}"
      DOTFILES_BASE_PATH.children.select { |p| p.file? }.each do |original_file|
        symlink = HOME_PATH + original_file.basename
        Dotfiles::Utils.safe_symlink original_file, symlink
      end
    end

    task :dotfiles_for_machine do
      next unless DOTFILES_MACHINE_PATH.exist?
      puts "Symlinking machine specific dotfiles: #{DOTFILES_MACHINE_PATH}"
      DOTFILES_MACHINE_PATH.children.select { |p| p.file? }.each do |original_file|
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

  namespace :vim do
    task :install do
      FileUtils.cd "#{VIM_PATH}/.bundle" do |_|
        sh "git submodule init"
        sh "git submodule update"
      end
      ctrlpc_matcher_path = "#{VIM_PATH}/.bundle/ctrlp-cmatcher"
      unless File.exists? "#{ctrlpc_matcher_path}/autoload/fuzzycomt.so"
        FileUtils.cd ctrlpc_matcher_path do |_|
          sh "./install.sh"
        end
      end
    end
  end

  desc "Installs dotfiles"
  task install: %w[symlink:dotfiles symlink:dotdirs vim:install]

  desc "remove all backed up files"
  task :cleanup do
    FileUtils.remove_entry_secure BACKUPS_PATH, :force => true
    FileUtils.mkdir BACKUPS_PATH
    FileUtils.touch "#{BACKUPS_PATH}/.gitkeep"
  end

  desc "show help"
  task :help do
    puts "Use `rake install` to install dotfiles"
  end
end

task :default => 'setup:help'
task :install => 'setup:install'
task :cleanup => 'setup:cleanup'
