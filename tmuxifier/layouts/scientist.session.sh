# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "scientist"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "snow-scientist"; then

  # Create a new window inline within session layout definition.
  # new_window "In-line Window"
  # tmux split-window -h -p 50

  # Load a defined window layout.
  load_window "run_scientist"
  load_window "code"

  # Select the default active window on session creation.
  # select_window 0

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
