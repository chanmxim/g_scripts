CURRENT_LOCATION="${PWD}"
FOLDER_NAME="$(basename "${CURRENT_LOCATION}")"
SESSION_NAME="project_${FOLDER_NAME}"

echo "Starting tmux session: ${SESSION_NAME}"

if tmux has-session -t "${SESSION_NAME}" 2>/dev/null; then
  echo "Session ${SESSION_NAME} already exists. Attaching to the existing session..."
else
  # Get width and height of the current terminal window
  TERM_COLS="$(tput cols)"
  TERM_LINES="$(tput lines)"

  tmux new-session -d -x "${TERM_COLS}" -y "${TERM_LINES}" -s "${SESSION_NAME}" -c "${CURRENT_LOCATION}"

  # Create left pane 40 column wide
  tmux split-window -h -b -l 40 -t "${SESSION_NAME}" -c "${CURRENT_LOCATION}"
fi

tmux attach-session -t "${SESSION_NAME}"

