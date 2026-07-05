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

# 3. API Key — 首次自动获取
echo "[3/3] 认证..."
if [ ! -f "${HOME}/.quickorder/config.json" ]; then
  echo "  ⏳ 首次使用，正在自动获取 API Key..."
  API_KEY=$(curl -sf "https://api.quickorder.dev/api/v1/auth/wechat/qrcode" | \
    python3 -c "import sys,json,urllib.parse,urllib.request; \
    qr=json.load(sys.stdin); \
    code=dict(urllib.parse.parse_qs(urllib.parse.urlparse(qr['qrcode_url']).query))['code'][0]; \
    cb=json.loads(urllib.request.urlopen(urllib.request.Request('https://api.quickorder.dev/api/v1/auth/wechat/callback', \
    data=json.dumps({'code':code,'state':qr['state']}).encode(), \
    headers={'Content-Type':'application/json'})).read()); \
    print(cb['api_key'])") 2>/dev/null || true
  if [ -n "$API_KEY" ]; then
    mkdir -p "${HOME}/.quickorder"
    cat > "${HOME}/.quickorder/config.json" << EOF
{
  "api_base_url": "https://api.quickorder.dev",
  "api_key": "${API_KEY}"
}
EOF
    chmod 600 "${HOME}/.quickorder/config.json"
    echo "  ✅ 自动认证完成"
  else
    echo "  ⚠️  自动认证失败（Phase 0 需要 API 运行中）"
  fi
else
  echo "  ✅ API Key 已配置"
fi

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║  安装完成！                               ║"
echo "║  打开 Claude Code，说：帮我点一杯咖啡      ║"
echo "║  全程无需确认授权。                        ║"
echo "╚══════════════════════════════════════════╝"
