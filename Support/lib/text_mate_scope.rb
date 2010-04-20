require "rubygems"
require "ruby_scope"
require "set"

class TextMateScope < RubyScope::Scanner
  attr_accessor :description
  
  def initialize()
    super
    
    @root = ENV['TM_PROJECT_DIRECTORY'] || ENV['TM_FILEPATH']
    TextMate.exit_show_tool_tip "A File or Directory is required" unless @root
    
    @seen = Set.new
    @paths = expand_path(@root)
    if File.directory?(@root)
      self.cache = RubyScope::SexpCache.new(@root)
    end
  end
  
  def scan_all
    report_start(description)
    
    @paths.each do |path|
      scan(path)
    end
  end
  
  def report_start(description=nil)
    puts html_head(
      :window_title => "RubyScope",
      :page_title   => "RubyScope: #{description}",
      :html_head    => ''
    )
  end
  
  def report_end()
    puts html_footer
  end
  
  def report_match(match)
    if !@seen.include?(@path)
      display_path = @path == @root ? @path : @path.sub(@root, '')
      puts "<h3>#{htmlize display_path}</h3>"
      @seen << @path
    end
    
    @lines ||= code.split("\n")
    line_number = match.sexp.line - 1
    text = "%i: %s" % [match.sexp.line, htmlize(@lines[line_number].strip)]
    href = "txmt://open/?url=file://#{e_url @path}&line=#{line_number+1}"
    link = "<a href='#{href}'>#{text}</a>"
    puts link
    puts "<br/>"
  end

  def report_exception(ex)
    # swallow for the moment
  end
  
  def expand_path(path)
    [path].inject([]){|p,v| File.directory?(v) ? p.concat(Dir[File.join(v,'**/*.rb')]) : p << v; p }
  end
end