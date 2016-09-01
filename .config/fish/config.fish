source /Users/zwimer/.bash_aliases

#Add !! command to fish
alias !!='eval command "$history[1]"'

#Add sudo !! to fish
function sudo
    if test "$argv" = !!
        eval command sudo $history[1]
    else
        command sudo $argv
    end
end

#Allow iTerm shell integration for fish 
test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
