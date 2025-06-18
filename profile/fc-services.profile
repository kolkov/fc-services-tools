# Aliases and functions for services management

# Load configuration
if [ -f /etc/conf.d/fc-services ]; then
    source /etc/conf.d/fc-services
fi

# Set default pattern if not configured
: ${SERVICE_PATTERN:="^fc-"}

# Main commands
alias fc-restart-deps='/usr/bin/fc-restart-deps'
alias fc-status='/usr/bin/fc-status'

# Service management
fc_service_list() {
    ls /etc/init.d/ | grep "$SERVICE_PATTERN"
}

alias fc-start='for s in $(fc_service_list); do /etc/init.d/$s start; done'
alias fc-stop='for s in $(fc_service_list); do /etc/init.d/$s stop; done'
alias fc-restart='for s in $(fc_service_list); do /etc/init.d/$s restart; done'

# Utilities
alias fc-list='fc_service_list'
alias fc-logs='tail -f /var/log/fc-*.log'
alias fc-deps='grep -EH "^(need|use)" /etc/init.d/* | grep "$SERVICE_PATTERN"'

# Batch operations
alias fc-restart-all='for s in $(fc_service_list); do fc-restart-deps $RESTART_OPTS $s; done'
alias fc-restart-dry='fc-restart-deps -d'

# Autocompletion
_fc_services_complete() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "$(fc_service_list)" -- "$cur") )
}
complete -F _fc_services_complete fc-restart-deps