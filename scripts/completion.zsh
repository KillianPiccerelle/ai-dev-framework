#!/usr/bin/env zsh

# Zsh completion script for ai-dev-framework
# Source this file or add to zsh completion directory

# Main commands
_ai_framework_commands=(
    'init[Initialize the framework in the current project]'
    'update[Update the framework to the latest version]'
    'install[Re-run global installation]'
    'version[Show version and check for updates]'
    'doctor[Run health check and diagnostics]'
    'list[List all available agents, workflows, and skills]'
)

# Version subcommands
_ai_framework_version_subcommands=(
    'show[Show current version and check for updates]'
    'check[Silent check for CI/CD]'
    'set[Update version file]'
    'help[Show help message]'
)

# Templates for init
_ai_framework_templates=(
    'saas[Multi-tenant SaaS with organizations and billing]'
    'api-backend[Pure REST/GraphQL API]'
    'fullstack-web[Fullstack web application]'
    'ai-app[Application with LLM features]'
)

# Version patterns for 'version set'
_ai_framework_version_patterns=(
    'v3.0.0'
    'v3.1.0'
    'v3.2.0'
    'v4.0.0'
)

_ai-framework() {
    local context state state_descr line
    typeset -A opt_args

    _arguments -C \
        '1: :->command' \
        '*:: :->args'

    case $state in
        command)
            _describe -t commands 'ai-framework command' _ai_framework_commands
            ;;
        args)
            case $line[1] in
                init)
                    _describe -t templates 'template' _ai_framework_templates
                    ;;
                version)
                    _describe -t subcommands 'version subcommand' _ai_framework_version_subcommands
                    ;;
                set)
                    # Only show version patterns if previous was 'version'
                    if [[ $line[-2] == "version" ]]; then
                        _describe -t versions 'version pattern' _ai_framework_version_patterns
                    fi
                    ;;
            esac
            ;;
    esac
}

# Register the completion function
compdef _ai-framework ai-framework

# If sourced directly, print instructions
if [[ -n $ZSH_EVAL_CONTEXT && $ZSH_EVAL_CONTEXT == toplevel ]]; then
    echo "Zsh completion for ai-framework installed."
    echo "To use immediately: source $0"
    echo "To install permanently:"
    echo "  mkdir -p ~/.zsh/completions"
    echo "  cp $0 ~/.zsh/completions/_ai-framework"
    echo "  Add to ~/.zshrc: fpath=(~/.zsh/completions \$fpath)"
    echo "  Then: autoload -Uz compinit && compinit"
fi