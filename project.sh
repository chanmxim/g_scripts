readonly CURRENT_LOCATION="${PWD}"
readonly FOLDER_NAME="$(basename "${CURRENT_LOCATION}")"
readonly SESSION_NAME="project_${FOLDER_NAME}"
readonly LEFT_PANE_WIDTH="40"

echo "Starting tmux session: ${SESSION_NAME}"

if tmux has-session -t "${SESSION_NAME}" 2>/dev/null; then
  echo "Session ${SESSION_NAME} already exists. Attaching to the existing session..."
else
  # Get width and height of the current terminal window
  readonly TERM_COLS="$(tput cols)"
  readonly TERM_LINES="$(tput lines)"

  tmux new-session -d -x "${TERM_COLS}" -y "${TERM_LINES}" -s "${SESSION_NAME}" -c "${CURRENT_LOCATION}"

  # Create left pane 40 column wide
  tmux split-window -h -b -l "$LEFT_PANE_WIDTH" -t "${SESSION_NAME}" -c "${CURRENT_LOCATION}"
fi

tmux attach-session -t "${SESSION_NAME}"

