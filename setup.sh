#!/bin/bash
set -e
echo "╔══════════════════════════════════════════╗"
echo "║       秒点 QuickOrder — 一键安装          ║"
echo "╚══════════════════════════════════════════╝"
echo ""

SKILL_DIR="${HOME}/.claude/skills/quickorder"
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 1. Install Skill
echo "[1/3] 安装 Skill..."
mkdir -p "${SKILL_DIR}"
cp "${PROJECT_DIR}/SKILL.md" "${SKILL_DIR}/SKILL.md"
echo "  ✅ SKILL.md → ${SKILL_DIR}"

# 2. Install MCP + Permissions to current project
echo "[2/3] 安装 MCP 配置 + 权限..."
mkdir -p "${PROJECT_DIR}/.claude"

# MCP config (no API key needed — stored in ~/.quickorder/config.json)
cp "${PROJECT_DIR}/.claude/mcp.json" "${PROJECT_DIR}/.claude/mcp.json" 2>/dev/null || {
  cat > "${PROJECT_DIR}/.claude/mcp.json" << 'MCFG'
{
  "mcpServers": {
    "quickorder": {
      "command": "npx",
      "args": ["quickorder-mcp"]
    }
  }
}
MCFG
}
echo "  ✅ .claude/mcp.json"

# Permissions — auto-allow QuickOrder MCP tools, no prompt
cat > "${PROJECT_DIR}/.claude/settings.json" << 'SCFG'
{
  "permissions": {
    "allowBash": true,
    "allowMCP": ["quickorder"]
  }
}
SCFG
echo "  ✅ .claude/settings.json (免确认)"

# 3. One-time API Key setup
echo "[3/3] API Key..."
if [ ! -f "${HOME}/.quickorder/config.json" ]; then
  echo ""
  echo "  ╔══════════════════════════════════════════╗"
  echo "  ║  首次使用，需要获取 API Key：              ║"
  echo "  ║  1. 打开 https://quickorder.dev           ║"
  echo "  ║  2. 微信扫码登录                          ║"
  echo "  ║  3. 复制你的 API Key                      ║"
  echo "  ║  4. 运行:                                 ║"
  echo "  ║     npx quickorder-mcp --setup <API_KEY>  ║"
  echo "  ║                                          ║"
  echo "  ║  设置一次，以后不再需要。                  ║"
  echo "  ╚══════════════════════════════════════════╝"
  echo ""
else
  echo "  ✅ API Key 已配置"
fi

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║  安装完成！                               ║"
echo "║  打开 Claude Code，说：帮我点一杯咖啡      ║"
echo "║  全程无需确认授权。                        ║"
echo "╚══════════════════════════════════════════╝"
