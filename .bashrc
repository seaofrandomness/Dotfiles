[[ $- != *i* ]] && return


#export http_proxy=socks5://localhost:9050
#export https_proxy=socks5://localhost:9050

# for fzf
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

# for direnv
eval "$(direnv hook bash)"

# for pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# for sourcing .venv
function cd() {
  builtin cd "$@"

  if [[ -z "$VIRTUAL_ENV" ]] ; then
    ## If env folder is found then activate the vitualenv
      if [[ -d ./.venv ]] ; then
        source ./.venv/bin/activate
      fi
  else
    ## check the current folder belong to earlier VIRTUAL_ENV folder
    # if yes then do nothing
    # else deactivate
      parentdir="$(dirname "$VIRTUAL_ENV")"
      if [[ "$PWD"/ != "$parentdir"/* ]] ; then
        deactivate
      fi
  fi
}




encrypt_file() {
    if [ $# -ne 1 ]; then
        echo "Usage: krypt <filename>"
        return 1
    fi
    
    local filename="$1"
    local encrypted_filename="$filename.enc"
    
    # Check if the file exists
    if [ ! -f "$filename" ]; then
        echo "Error: File '$filename' not found"
        return 1
    fi
    
    # Prompt for password
    read -rsp "Enter password: " password
    echo
    
    # Encrypt the file
    openssl enc -in "$filename" -aes-256-cbc -pass "pass:$password" -out "$encrypted_filename"
    
    echo "File encrypted successfully: $encrypted_filename"
}
alias hdmi_off="xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --off"
alias hdmi_office="xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x1080 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --mode 1920x1080 --pos 0x0 --rotate normal"
alias krypt='encrypt_file'
alias newip='sudo kill -HUP `pidof tor`'
alias ls='lsd --color=auto --group-directories-first'
alias l='lsd --color=auto --group-directories-first'
alias ll='lsd --color=auto --group-directories-first -l'
alias la='lsd --color=auto --group-directories-first -la'
alias r='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

mirror_webcam() {
	sudo modprobe v4l2loopback video_nr=9 card_label="WebCam Flipped" exclusive_caps=1
	sudo ffmpeg -f v4l2 -framerate 60 -video_size 640x480 -i /dev/video0 -vf hflip -pix_fmt yuyv422 -f v4l2 /dev/video9
}

parse_git_branch() {
   git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PS1="\[\e[35m\]\W\[\e[m\]\[\033[33m\]\$(parse_git_branch)\[\e[31m\] ⛧ \[\e[m\] "

