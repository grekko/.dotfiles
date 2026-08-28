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
      if !File.exist? source
        warn "skipping #{target}: #{source} does not exist"
        return
      end

      if File.symlink? target
        puts "removing old symlink: #{target}"
        FileUtils.rm target
      elsif File.exist? target
        puts "backing up existing file/dir #{target}"
        bak_path = BACKUPS_PATH + "#{File.basename(target)}-#{BAK_TIME_ID}"
        bak_path.mkpath
        puts " \tmoving #{target} -> #{bak_path}"
        FileUtils.mv target, bak_path
        adopt_machine_local(bak_path + File.basename(target), source)
      end

      FileUtils.ln_s source, target
      puts "~> creating symlink: #{target} -> #{source}"
    end

    # Carry machine-local files across the switch from a real directory to a
    # symlink. Some dotdirs are deliberately gitignored (dotdirs/.ssh/* is,
    # apart from .gitkeep), so a fresh clone has an EMPTY source and replacing
    # the target outright would take ~/.ssh/authorized_keys and known_hosts
    # offline with it — on a machine you administer over SSH, that is a
    # lockout. Anything the repo already provides wins; the backup is left
    # untouched either way.
    def adopt_machine_local(moved, source)
      return unless File.directory?(moved) && File.directory?(source)

      Pathname.new(moved).children.each do |entry|
        dest = Pathname.new(source) + entry.basename
        next if dest.exist? || dest.symlink?

        puts " \tkeeping machine-local #{entry.basename} -> #{dest}"
        FileUtils.cp_r entry, dest, preserve: true
      end
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

  namespace :bash do
    task :install do
      bashrc = HOME_PATH + ".bashrc"
      bashrc_local = HOME_PATH + ".bashrc_local"
      puts "------------"
      if File.exist?(bashrc) || File.symlink?(bashrc)
        puts "The system already provides a ~/.bashrc file. You need to manually include ~/.bashrc_local"
      else
        puts "Symlinking ~/.bashrc -> ~/.bashrc_local"
        FileUtils.ln_s bashrc_local, bashrc
      end
      puts "------------"
    end
  end

  namespace :vim do
    task :install do
      FileUtils.cd "#{VIM_PATH}/bundle" do |_|
        sh "git submodule init"
        sh "git submodule update"
      end
    end
  end

  namespace :claude do
    task :install do
      puts "Symlinking Claude Code commands"
      claude_dir = HOME_PATH + ".claude"
      FileUtils.mkdir_p claude_dir unless claude_dir.exist?

      {commands: "commands", skills: "skills"}.each do |name, dir|
        source = BASE_PATH + "claude" + dir
        target = claude_dir + dir
        Dotfiles::Utils.safe_symlink source, target
      end
    end
  end

  desc "Installs dotfiles"
  task install: %w[symlink:dotfiles symlink:dotdirs vim:install bash:install claude:install]

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
