#!/bin/bash
set -e
echo "╔══════════════════════════════════════════╗"
echo "║       秒点 QuickOrder — 一键安装          ║"
echo "╚══════════════════════════════════════════╝"
echo ""

SKILL_DIR="${HOME}/.claude/skills/quickorder"
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 1. Install Skill
echo "[1/2] 安装 Skill..."
mkdir -p "${SKILL_DIR}"
cp "${PROJECT_DIR}/SKILL.md" "${SKILL_DIR}/SKILL.md"
echo "  ✅ SKILL.md → ${SKILL_DIR}"

# 2. Install MCP config
echo "[2/2] 安装 MCP 配置..."
if [ ! -f "${PROJECT_DIR}/.claude/mcp.json" ]; then
  cp "${PROJECT_DIR}/.claude/mcp.json.template" "${PROJECT_DIR}/.claude/mcp.json"
  echo "  ✅ MCP 配置模板已创建"
  echo "  ⚠️  请编辑 .claude/mcp.json 填入你的 QUICKORDER_API_KEY"
else
  echo "  ✅ MCP 配置已存在"
fi

# 3. Permissions
mkdir -p "${PROJECT_DIR}/.claude"
cp "${PROJECT_DIR}/.claude/settings.json" "${PROJECT_DIR}/.claude/settings.json" 2>/dev/null || true

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║  安装完成！                               ║"
echo "║  打开 Claude Code，说：帮我点一杯咖啡      ║"
echo "╚══════════════════════════════════════════╝"
