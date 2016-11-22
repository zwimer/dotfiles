#Read by both bash and fish

#--------------------General purpose-------------------- 

#Allow g++ to default to c++ 11 with comments
alias g++='g++ -Wall -std=c++11'

#Allow gcc to default include comments
alias gcc='gcc -Wall'

#To prevent from forgetting the -E
alias sudofish='sudo -E fish'

#Git log alias
alias gl='git log --graph --oneline --decorate --all'

#Git status alias
alias gis='git status'


#-------------------Computer specific-------------------

#Allow purge to run without sudo
alias purge='sudo purge'

#Drracket
alias drracket='/Applications/Racket\ v6.4/bin/drracket'

#Commandline racket
alias racket='/Applications/Racket\ v6.4/bin/racket'

#Make java script easier
alias js="/System/Library/Frameworks/JavaScriptCore.framework/Versions/Current/Resources/jsc"
