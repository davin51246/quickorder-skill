# 秒点 QuickOrder Skill

AI 下单助手 — "一句话，就点好"。Claude Code 安装此 Skill 后，通过对话即可完成搜索商家、匹配商品、下单、追踪订单。

## 安装

```bash
# 1. 克隆仓库
git clone https://github.com/quickorder/quickorder-skill.git
cd quickorder-skill

# 2. 一键安装
./setup.sh
```

## 使用

打开 Claude Code，直接说：

```
"帮我点一杯拿铁"
"附近有什么咖啡店"
"我的订单到哪了"
"再来一单"
```

## 前置条件

- Claude Code 已安装
- 已在秒点平台注册 API Key（访问 quickorder.dev 微信扫码获取）

## 文件说明

```
quickorder-skill/
├── SKILL.md              # Skill 指令
├── setup.sh              # 一键安装脚本
├── README.md             # 本文件
├── .claude/
│   ├── mcp.json.template # MCP 配置模板
│   └── settings.json     # 权限配置（免确认）
└── examples/
    └── demo.md           # 示例对话
```
