# TextMate Support
require "exit_codes"
require "ui"
require "web_preview"

# RubyScope Support
require "text_mate_scope"

def fail msg
  puts msg
  exit 1
end

def get_term
  term = ENV['TM_CURRENT_WORD']
  fail "Place the cursor over the term you wish to search for" unless term
  term
end