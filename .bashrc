#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
alias pipes='/home/frqme/pipes.sh/pipes.sh -c 7 -c 15'
export PATH="$HOME/.local/bin:$PATH"

. "$HOME/.local/share/../bin/env"
# Function to generate the gradient for any string length
gradient_prompt() {
    local str="${PWD##*/}" # Get only the current folder name
    [[ -z "$str" ]] && str="/" # Handle the root directory
    
    local len=${#str}
    local start_r=255 start_g=255 start_b=255   # White
    local end_r=150   end_g=150   end_b=150   # Light Gray
    
    local result=""
    for (( i=0; i<len; i++ )); do
        # Interpolate RGB values based on the character's position
        local r=$(( start_r + (end_r - start_r) * i / (len > 1 ? len - 1 : 1) ))
        local g=$(( start_g + (end_g - start_g) * i / (len > 1 ? len - 1 : 1) ))
        local b=$(( start_b + (end_b - start_b) * i / (len > 1 ? len - 1 : 1) ))
        
        # Build the ANSI escape sequence for each character
        result+="\[\e[38;2;${r};${g};${b}m\]${str:i:1}"
    done
    
    # Set the final PS1 with the gradient and the reset code
    PS1="${result}\[\e[0m\] > "
}

# Run the function to set the prompt
PROMPT_COMMAND=gradient_prompt
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
. "$HOME/.cargo/env"
