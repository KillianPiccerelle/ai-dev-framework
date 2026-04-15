#!/usr/bin/env bash

# Bash completion script for ai-dev-framework
# Source this file or add to bash completion directory

_ai_framework_completion() {
    local cur prev words cword
    _init_completion || return

    # Main commands
    local commands="init update install version doctor list"

    # Version subcommands
    local version_subcommands="show check set help"

    # Templates for init
    local templates="saas api-backend fullstack-web ai-app mobile-backend cli-tool data-pipeline monorepo"

    case $prev in
        ai-framework)
            COMPREPLY=($(compgen -W "$commands" -- "$cur"))
            return 0
            ;;
        init)
            COMPREPLY=($(compgen -W "$templates" -- "$cur"))
            return 0
            ;;
        version)
            COMPREPLY=($(compgen -W "$version_subcommands" -- "$cur"))
            return 0
            ;;
        set)
            # Only complete 'set' if previous was 'version'
            if [ "${COMP_WORDS[COMP_CWORD-2]}" = "version" ]; then
                # Suggest version patterns
                local version_patterns="v3.0.0 v3.1.0 v3.2.0 v4.0.0"
                COMPREPLY=($(compgen -W "$version_patterns" -- "$cur"))
            fi
            return 0
            ;;
    esac

    # Handle subcommands
    case ${COMP_WORDS[1]} in
        version)
            if [ $cword -eq 2 ]; then
                COMPREPLY=($(compgen -W "$version_subcommands" -- "$cur"))
            elif [ $cword -eq 3 ] && [ "$prev" = "set" ]; then
                # Suggest version patterns for 'version set'
                local version_patterns="v3.0.0 v3.1.0 v3.2.0 v4.0.0"
                COMPREPLY=($(compgen -W "$version_patterns" -- "$cur"))
            fi
            ;;
        init)
            if [ $cword -eq 2 ]; then
                COMPREPLY=($(compgen -W "$templates" -- "$cur"))
            fi
            ;;
    esac

    # If we're at command level and haven't matched anything
    if [ $cword -eq 1 ]; then
        COMPREPLY=($(compgen -W "$commands" -- "$cur"))
    fi
}

complete -F _ai_framework_completion ai-framework

# Also add completion for the script itself if called directly
# This check doesn't work well when sourced from install.sh
# Just define the completion function quietly