#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# GEO-SEO AI CLI Skill Installer
# Installs the GEO-first SEO analysis tool for Claude/Gemini/Copilot CLI
# ============================================================

REPO_URL="https://github.com/zubair-trabzada/geo-seo-claude.git"
TARGET_CLI="claude"
CLI_HOME_DIR=""
SKILLS_DIR=""
AGENTS_DIR=""
INSTALL_DIR="${SKILLS_DIR}/geo"
TEMP_DIR=$(mktemp -d)

# Detect if running via curl pipe (no interactive input available)
INTERACTIVE=true
if [ ! -t 0 ]; then
    INTERACTIVE=false
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   GEO-SEO AI CLI Skill Installer         ║${NC}"
    echo -e "${BLUE}║   GEO-First AI Search Optimization       ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════╝${NC}"
    echo ""
}

print_usage() {
    cat <<EOF
Usage: ./install.sh [--cli claude|gemini|copilot] [--base-dir PATH]

Options:
  --cli       Target CLI platform (default: claude)
  --base-dir  Override CLI config directory (e.g. ~/.claude, ~/.gemini)
  --help      Show this help message
EOF
}

resolve_cli_dir() {
    case "$TARGET_CLI" in
        claude) echo "${HOME}/.claude" ;;
        gemini) echo "${HOME}/.gemini" ;;
        copilot) echo "${HOME}/.copilot" ;;
        *)
            print_error "Unsupported --cli value: ${TARGET_CLI}"
            print_usage
            exit 1
            ;;
    esac
}

has_target_cli() {
    case "$TARGET_CLI" in
        claude) command -v claude &> /dev/null ;;
        gemini) command -v gemini &> /dev/null ;;
        copilot) has_copilot_cli ;;
        *) return 1 ;;
    esac
}

has_copilot_cli() {
    command -v copilot &> /dev/null && return 0
    command -v github-copilot-cli &> /dev/null && return 0
    command -v gh &> /dev/null && gh copilot --help &> /dev/null && return 0
    return 1
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}→ $1${NC}"
}

cleanup() {
    rm -rf "$TEMP_DIR"
}

trap cleanup EXIT

main() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --cli)
                TARGET_CLI="${2:-}"
                shift 2
                ;;
            --base-dir)
                CLI_HOME_DIR="${2:-}"
                shift 2
                ;;
            --help|-h)
                print_usage
                exit 0
                ;;
            *)
                print_error "Unknown argument: $1"
                print_usage
                exit 1
                ;;
        esac
    done

    TARGET_CLI="$(echo "$TARGET_CLI" | tr '[:upper:]' '[:lower:]')"
    if [ -z "$CLI_HOME_DIR" ]; then
        CLI_HOME_DIR="$(resolve_cli_dir)"
    fi
    SKILLS_DIR="${CLI_HOME_DIR}/skills"
    AGENTS_DIR="${CLI_HOME_DIR}/agents"
    INSTALL_DIR="${SKILLS_DIR}/geo"

    print_header

    # ---- Check Prerequisites ----
    print_info "Checking prerequisites..."

    # Check for Git
    if ! command -v git &> /dev/null; then
        print_error "Git is required but not installed."
        echo "  Install: https://git-scm.com/downloads"
        exit 1
    fi
    print_success "Git found: $(git --version)"

    # Check for Python 3
    PYTHON_CMD=""
    if command -v python3 &> /dev/null; then
        PYTHON_CMD="python3"
    elif command -v python &> /dev/null; then
        PYTHON_VERSION=$(python --version 2>&1 | grep -oE '[0-9]+\.[0-9]+' | head -1)
        if [ -n "$PYTHON_VERSION" ]; then
            MAJOR=$(echo "$PYTHON_VERSION" | cut -d. -f1)
            MINOR=$(echo "$PYTHON_VERSION" | cut -d. -f2)
            if [ "$MAJOR" -ge 3 ] && [ "$MINOR" -ge 8 ]; then
                PYTHON_CMD="python"
            fi
        fi
    fi

    if [ -z "$PYTHON_CMD" ]; then
        print_error "Python 3.8+ is required but not found."
        echo "  Install: https://www.python.org/downloads/"
        exit 1
    fi
    print_success "Python found: $($PYTHON_CMD --version)"

    # Check for target CLI
    CLI_EXECUTABLE="$TARGET_CLI"
    case "$TARGET_CLI" in
        claude) CLI_DISPLAY_NAME="Claude" ;;
        gemini) CLI_DISPLAY_NAME="Gemini" ;;
        copilot) CLI_DISPLAY_NAME="Copilot" ;;
        *) CLI_DISPLAY_NAME="$(echo "${TARGET_CLI:0:1}" | tr '[:lower:]' '[:upper:]')${TARGET_CLI:1}" ;;
    esac
    CLI_INSTALL_HINT="Install your selected CLI and ensure '${CLI_EXECUTABLE}' is in PATH."
    case "$TARGET_CLI" in
        claude)
            CLI_INSTALL_HINT="Install: npm install -g @anthropic-ai/claude-code"
            ;;
        gemini)
            CLI_INSTALL_HINT="Gemini CLI support is experimental; ensure 'gemini' is in PATH or use --base-dir."
            ;;
        copilot)
            CLI_DISPLAY_NAME="Copilot"
            CLI_INSTALL_HINT="Install GitHub Copilot CLI (or gh with Copilot) and ensure one of: copilot, github-copilot-cli, gh."
            ;;
    esac
    if ! has_target_cli; then
        print_warning "${CLI_DISPLAY_NAME} CLI not found in PATH."
        echo "  Installation can continue, but running /geo commands requires ${CLI_DISPLAY_NAME} CLI."
        echo "  ${CLI_INSTALL_HINT}"
        echo ""
        if [ "$INTERACTIVE" = true ]; then
            read -p "Continue installation anyway? (y/n): " -n 1 -r
            echo ""
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 1
            fi
        else
            print_info "Non-interactive mode — continuing anyway..."
        fi
    else
        print_success "${CLI_DISPLAY_NAME} CLI found"
    fi

    # ---- Create Directories ----
    print_info "Creating directories..."

    mkdir -p "$SKILLS_DIR"
    mkdir -p "$AGENTS_DIR"
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$INSTALL_DIR/scripts"
    mkdir -p "$INSTALL_DIR/schema"
    mkdir -p "$INSTALL_DIR/hooks"

    print_success "Directory structure created"

    # ---- Clone or Copy Repository ----
    print_info "Fetching GEO-SEO skill files..."

    # Check if running from the repo directory (local install)
    # BASH_SOURCE may be empty when piped via curl, so handle gracefully
    SCRIPT_DIR=""
    if [ -n "${BASH_SOURCE[0]:-}" ] && [ "${BASH_SOURCE[0]}" != "bash" ]; then
        SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)" || true
    fi

    if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/geo/SKILL.md" ]; then
        print_info "Installing from local directory..."
        SOURCE_DIR="$SCRIPT_DIR"
    else
        print_info "Cloning from repository..."
        git clone --depth 1 "$REPO_URL" "$TEMP_DIR/repo" || {
            print_error "Failed to clone repository. Check your internet connection."
            exit 1
        }
        SOURCE_DIR="${TEMP_DIR}/repo"
    fi

    # ---- Install Main Skill ----
    print_info "Installing main GEO skill..."

    cp -r "$SOURCE_DIR/geo/"* "$INSTALL_DIR/"
    print_success "Main skill installed → ${INSTALL_DIR}/"

    # ---- Install Sub-Skills ----
    print_info "Installing sub-skills..."

    SKILL_COUNT=0
    for skill_dir in "$SOURCE_DIR/skills"/*/; do
        if [ -d "$skill_dir" ]; then
            skill_name=$(basename "$skill_dir")
            target_dir="${SKILLS_DIR}/${skill_name}"
            mkdir -p "$target_dir"
            cp -r "$skill_dir"* "$target_dir/"
            SKILL_COUNT=$((SKILL_COUNT + 1))
            print_success "  ${skill_name}"
        fi
    done
    echo "  → ${SKILL_COUNT} sub-skills installed"

    # ---- Install Agents ----
    print_info "Installing subagents..."

    AGENT_COUNT=0
    for agent_file in "$SOURCE_DIR/agents/"*.md; do
        if [ -f "$agent_file" ]; then
            cp "$agent_file" "$AGENTS_DIR/"
            AGENT_COUNT=$((AGENT_COUNT + 1))
            print_success "  $(basename "$agent_file")"
        fi
    done
    echo "  → ${AGENT_COUNT} subagents installed"

    # ---- Install Scripts ----
    print_info "Installing utility scripts..."

    if [ -d "$SOURCE_DIR/scripts" ]; then
        cp -r "$SOURCE_DIR/scripts/"* "$INSTALL_DIR/scripts/"
        chmod +x "$INSTALL_DIR/scripts/"*.py 2>/dev/null || true
        print_success "Scripts installed → ${INSTALL_DIR}/scripts/"
    fi

    # ---- Install Schema Templates ----
    print_info "Installing schema templates..."

    if [ -d "$SOURCE_DIR/schema" ]; then
        cp -r "$SOURCE_DIR/schema/"* "$INSTALL_DIR/schema/"
        print_success "Schema templates installed → ${INSTALL_DIR}/schema/"
    fi

    # ---- Install Hooks ----
    if [ -d "$SOURCE_DIR/hooks" ] && [ "$(ls -A "$SOURCE_DIR/hooks" 2>/dev/null)" ]; then
        print_info "Installing hooks..."
        cp -r "$SOURCE_DIR/hooks/"* "$INSTALL_DIR/hooks/"
        chmod +x "$INSTALL_DIR/hooks/"* 2>/dev/null || true
        print_success "Hooks installed → ${INSTALL_DIR}/hooks/"
    fi

    # ---- Install Python Dependencies ----
    print_info "Installing Python dependencies..."

    if [ -f "$SOURCE_DIR/requirements.txt" ]; then
        $PYTHON_CMD -m pip install -r "$SOURCE_DIR/requirements.txt" --quiet 2>/dev/null && {
            print_success "Python dependencies installed"
        } || {
            print_warning "Some Python dependencies failed to install."
            echo "  Run manually: $PYTHON_CMD -m pip install -r requirements.txt"
            cp "$SOURCE_DIR/requirements.txt" "$INSTALL_DIR/"
        }
    fi

    # ---- Optional: Install Playwright ----
    if [ "$INTERACTIVE" = true ]; then
        echo ""
        read -p "Install Playwright for screenshots? (y/n): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_info "Installing Playwright browsers..."
            $PYTHON_CMD -m playwright install chromium 2>/dev/null && {
                print_success "Playwright Chromium installed"
            } || {
                print_warning "Playwright installation failed. Screenshots won't be available."
            }
        fi
    else
        print_info "Skipping Playwright (non-interactive mode). Install later with: python3 -m playwright install chromium"
    fi

    # ---- Verify Installation ----
    echo ""
    print_info "Verifying installation..."

    VERIFY_OK=true

    [ -f "$INSTALL_DIR/SKILL.md" ] && print_success "Main skill file" || { print_error "Main skill file missing"; VERIFY_OK=false; }
    [ -d "$SKILLS_DIR/geo-audit" ] && print_success "Sub-skills directory" || { print_error "Sub-skills missing"; VERIFY_OK=false; }
    [ "$(ls "$AGENTS_DIR"/geo-*.md 2>/dev/null | wc -l)" -gt 0 ] && print_success "Agent files" || { print_error "Agent files missing"; VERIFY_OK=false; }
    [ -d "$INSTALL_DIR/scripts" ] && print_success "Utility scripts" || { print_error "Scripts missing"; VERIFY_OK=false; }
    [ -d "$INSTALL_DIR/schema" ] && print_success "Schema templates" || { print_error "Schema templates missing"; VERIFY_OK=false; }

    # ---- Print Summary ----
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║        Installation Complete!             ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo "  Installed to: ${INSTALL_DIR}"
    echo "  CLI target:   ${TARGET_CLI} (${CLI_HOME_DIR})"
    echo "  Skills:       ${SKILL_COUNT} sub-skills"
    echo "  Agents:       ${AGENT_COUNT} subagents"
    echo ""
    echo -e "${BLUE}Quick Start:${NC}"
    echo "  Open ${CLI_DISPLAY_NAME} CLI and try:"
    echo ""
    echo "    /geo audit https://example.com"
    echo "    /geo quick https://example.com"
    echo "    /geo citability https://example.com/blog/article"
    echo "    /geo crawlers https://example.com"
    echo "    /geo report https://example.com"
    echo ""
    echo -e "${BLUE}Available Commands:${NC}"
    echo "    /geo audit <url>      Full GEO + SEO audit"
    echo "    /geo quick <url>      60-second visibility snapshot"
    echo "    /geo citability <url> AI citation readiness score"
    echo "    /geo crawlers <url>   AI crawler access check"
    echo "    /geo llmstxt <url>    Analyze/generate llms.txt"
    echo "    /geo brands <url>     Brand mention scan"
    echo "    /geo platforms <url>  Platform-specific optimization"
    echo "    /geo schema <url>     Structured data analysis"
    echo "    /geo technical <url>  Technical SEO audit"
    echo "    /geo content <url>    Content quality & E-E-A-T"
    echo "    /geo report <url>     Client-ready GEO report"
    echo "    /geo report-pdf       Generate PDF report from audit data"
    echo ""
    echo "  Documentation: https://github.com/zubair-trabzada/geo-seo-claude"
    echo ""
}

main "$@"
