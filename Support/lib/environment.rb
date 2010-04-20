# TextMate Support
require "exit_codes"
require "ui"
require "web_preview"

# RubyScope Support
require "text_mate_scope"

def get_term
  term = ENV['TM_CURRENT_WORD']
  if !term || term =~ /^\s*$/
    TextMate.exit_show_tool_tip "Place the cursor over the term you wish to search for"
  end
  term
end