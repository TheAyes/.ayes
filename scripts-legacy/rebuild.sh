#! /run/current-system/sw/bin/bash
DIR=$(git rev-parse --show-toplevel)
MESSAGE=$("$DIR"/scripts/commit_message.sh)

if nh os switch "$DIR" --ask --diff=auto; then
  tide configure --auto --style=Lean --prompt_colors='True color' --show_time='24-hour format' --lean_prompt_height='Two lines' --prompt_connection=Dotted --prompt_connection_andor_frame_color=Dark --prompt_spacing=Sparse --icons='Many icons' --transient=Yes

	sudo mount --bind /etc/nixos/common/users/ayes/external/xlcore ~/.xlcore

  git add .
  git commit -m "$MESSAGE"
fi