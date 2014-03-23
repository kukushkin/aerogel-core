# Middleware which checks and reloads modified files.
#
module Aerogel
class Reloader

  attr_accessor :files, :group, :opts, :action

  # Use as middleware:
  #
  #   # single file
  #   use Aerogel::Reloader, "file1.rb" { load 'file1.rb' }
  #
  #   # list of files
  #   use Aerogel::Reloader, ["file1.rb", "file2.rb"] do |files|
  #     files.each{|f| load f }
  #   end
  #
  #   # dynamic list of files
  #   use Aerogel::Reloader, ->(){ Dir.glob["*.rb"] } do |files|
  #     files.each{|f| load f}
  #   end
  #
  #   # named groups of files
  #   use Aerogel::Reloader, "routes/*.rb", group: :routes do |files|
  #       files.each{|f| load f }
  #   end
  #
  #   # adding observer on a named group
  #   use Aerogel::Reloader, :routes, before: true do |files|
  #     # do more stuff before group :routes is reloaded
  #   end
  #
  #   Valid options are:
  #     :group => name group of files
  #     :before => if true invoke action block before group is reloaded
  #     :after => if true invoke action block after group is reloaded
  #
  #
  def initialize( app, files, opts = {}, &blk )
    @app = app
    if files.is_a? Symbol
      @group = files
      @files = nil
    else
      @files = files
      @group = opts[:group]
    end
    @opts = opts
    @action = blk
    @file_list = file_list( @files ) if @files
    @signature = signature( @file_list ) if @file_list
    Aerogel::Reloader.reloaders << self
  end

  def call( env )
    check!
    @app.call( env )
  end

  def self.reloaders
    @reloaders ||= []
  end

private

  # Checks if files are changed and reloads if so.
  #
  def check!
    return unless @files
    @file_list = file_list( @files )
    new_signature = signature( @file_list )
    if @signature != new_signature
      # reload file list
      puts "* Aerogel::Reloader reloading: #{@file_list}, group: #{@group}"
      if @group
        # invoke :before group actions
        Aerogel::Reloader.reloaders.select{|r| r.group == @group && r.opts[:before] }.each do |r|
          r.action.call @file_list
        end
      end
      @action.call @file_list
      @signature = new_signature
      if @group
        # invoke :after group actions
        Aerogel::Reloader.reloaders.select{|r| r.group == @group && r.opts[:after] }.each do |r|
          r.action.call @file_list
        end
      end
    end
  end

  # Re-calculates file list
  #
  def file_list( files )
    case files
    when String
      [files]
    when Array
      files
    when Proc
      files.call # result should respond to #each
    else
      []
    end
  end

  def signature( file_list )
    sig = []
    file_list.each do |filename|
      sig << File.mtime(filename).to_i
    end
    sig.sort
  end

end # class Reloader
end # module Aerogel
