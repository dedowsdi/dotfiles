# source ~/.gdbinit.d/glm_pretty_printer.py

# history {{{1

set history save on
set history size 4096
set history expansion on

# comment this if you prefer default history file ./.gdbhistory
set history filename ~/.gdbhistory

# remove duplicates in last 256 entries, change 256 to unlimited if want 0 duplicates.
set history remove-duplicates 256

# vim:set foldmethod=marker:
