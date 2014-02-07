# Middleware which checks and reloads modified files.
#
module Aerogel
class Reloader
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
  def initialize( app, files, &blk )
    @app = app
    @files = files
    @action = blk
    @file_list = file_list( @files )
    @signature = signature( @file_list )
  end

  def call( env )
    check!
    @app.call( env )
  end

private

  # Checks if files are changed and reloads if so.
  #
  def check!
    @file_list = file_list( @files )
    new_signature = signature( @file_list )
    if @signature != new_signature
      # reload file list
      puts "* Aerogel::Reloader reloading: #{@file_list}"
      @action.call @file_list
      @signature = new_signature
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
