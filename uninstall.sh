#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# GEO-SEO AI CLI Skill Uninstaller
# ============================================================

TARGET_CLI="claude"
CLI_HOME_DIR=""
SKILLS_DIR=""
AGENTS_DIR=""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_usage() {
    cat <<EOF
Usage: ./uninstall.sh [--cli claude|gemini] [--base-dir PATH]

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
        *)
            echo -e "${RED}Unsupported --cli value: ${TARGET_CLI}${NC}"
            print_usage
            exit 1
            ;;
    esac
}

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
            echo -e "${RED}Unknown argument: $1${NC}"
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

echo ""
echo -e "${YELLOW}GEO-SEO ${TARGET_CLI^} CLI Skill Uninstaller${NC}"
echo ""
echo "This will remove the following:"
echo ""

# List what will be removed
[ -d "$SKILLS_DIR/geo" ] && echo "  → ${SKILLS_DIR}/geo/"
for skill_dir in "$SKILLS_DIR"/geo-*/; do
    [ -d "$skill_dir" ] && echo "  → ${skill_dir}"
done
for agent_file in "$AGENTS_DIR"/geo-*.md; do
    [ -f "$agent_file" ] && echo "  → ${agent_file}"
done
if [ "$TARGET_CLI" = "gemini" ] && [ -d "$CLI_HOME_DIR/commands/geo" ]; then
    echo "  → ${CLI_HOME_DIR}/commands/geo/"
fi

echo ""
read -p "Are you sure you want to uninstall? (y/n): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Uninstall cancelled."
    exit 0
fi

echo ""

# Remove main skill
if [ -d "$SKILLS_DIR/geo" ]; then
    rm -rf "$SKILLS_DIR/geo"
    echo -e "${GREEN}✓ Removed main skill${NC}"
fi

# Remove sub-skills
for skill_dir in "$SKILLS_DIR"/geo-*/; do
    if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")
        rm -rf "$skill_dir"
        echo -e "${GREEN}✓ Removed ${skill_name}${NC}"
    fi
done

# Remove agents
for agent_file in "$AGENTS_DIR"/geo-*.md; do
    if [ -f "$agent_file" ]; then
        agent_name=$(basename "$agent_file")
        rm -f "$agent_file"
        echo -e "${GREEN}✓ Removed ${agent_name}${NC}"
    fi
done

# Remove Gemini commands
if [ "$TARGET_CLI" = "gemini" ] && [ -d "$CLI_HOME_DIR/commands/geo" ]; then
    rm -rf "$CLI_HOME_DIR/commands/geo"
    echo -e "${GREEN}✓ Removed Gemini custom commands${NC}"
fi

echo ""
echo -e "${GREEN}GEO-SEO skill has been uninstalled.${NC}"
echo ""
echo "Note: Python dependencies were not removed."
echo "To remove them manually:"
echo "  pip uninstall beautifulsoup4 requests lxml playwright Pillow validators"
echo ""
