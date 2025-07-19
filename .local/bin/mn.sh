#!/bin/bash

NOTES_DIR="$HOME/notes"
# https://github.com/junegunn/fzf/blob/master/ADVANCED.md#toggling-with-a-single-key-binding
cd ${NOTES_DIR} && ${FZF_DEFAULT_COMMAND} |
  fzf --prompt 'Fd> ' \
      --header 'C-t: Toggle,C-l: View,Cr: Edit,' \
      --bind 'ctrl-t:transform:[[ ! $FZF_PROMPT =~ Fd ]] &&
              echo "change-prompt(Fd> )+change-preview-window(80%|right,border-left)+reload($FZF_DEFAULT_COMMAND)"  ||
              echo "change-prompt(Rg> )+change-preview-window(hidden)+reload(rg --column --line-number --no-heading --color=never --smart-case \"${*:-}\")"' \
      --bind 'enter:become($EDITOR {})' \
      --bind 'ctrl-l:become(bat {})' \
      --bind 'ctrl-s:toggle-sort' \
      --bind 'alt-k:preview-up,ctrl-u:preview-up' \
      --bind 'alt-j:preview-down,ctrl-d:preview-down' \
      --bind 'alt-w:toggle-preview-wrap' \
      --delimiter : \
      --preview-window 'right,80%,border-left,+{2}+3/3,~3' \
      --preview '[[ $FZF_PROMPT =~ Fd ]] && bat --color=always {} || bat --color=always {1} --highlight-line {2}'

# rg --column --line-number --no-heading --color=always --smart-case -- bash |
#   perl -pe 's/\n/\0/; s/^([^:]+:){3}/$&\n  /' |
#   fzf --read0 --ansi --highlight-line --multi --delimiter : \
#       --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
#       --preview-window '+{2}/4' --gap |
#   perl -ne '/^([^:]+:){3}/ and print'
