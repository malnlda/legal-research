#!/usr/bin/env bash
# 移除本仓库安装的软链，不删除任何 .bak.* 备份。
set -euo pipefail
TARGET_DIR="${HOME}/.claude/skills"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

unlink_one() {
  local name="$1"
  local dst="$TARGET_DIR/$name"
  if [[ -L "$dst" ]]; then
    local cur
    cur="$(readlink "$dst")"
    if [[ "$cur" == "$REPO_ROOT/skills/$name" || "$cur" == "$REPO_ROOT/external/$name" ]]; then
      rm "$dst"
      echo "  ✓ 已移除软链: $name"
      return
    fi
    echo "  ⏭  跳过（指向其他位置）: $name → $cur"
  else
    echo "  ⏭  不存在或非软链: $name"
  fi
}

echo "==> 卸载 legal-research 技能序列（不删 .bak 备份）"
unlink_one "legal-research"
unlink_one "yd-law-search"
unlink_one "yd-case-search"
unlink_one "cs-china-lawyer-analyst"
echo "==> 完成"
