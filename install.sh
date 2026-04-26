#!/usr/bin/env bash
# legal-research 安装脚本：把仓库内的 skills 软链到 ~/.claude/skills/
# 幂等：重复执行不报错，已存在的非软链目录会备份为 <name>.bak.<时间戳>
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${HOME}/.claude/skills"
TS="$(date +%Y%m%d-%H%M%S)"

mkdir -p "$TARGET_DIR"

link_skill() {
  local src="$1"      # 仓库内绝对路径
  local name="$2"     # ~/.claude/skills/ 下的名字
  local dst="$TARGET_DIR/$name"

  if [[ ! -d "$src" ]]; then
    echo "  ⚠️  源不存在，跳过: $src"
    return
  fi

  if [[ -L "$dst" ]]; then
    local cur
    cur="$(readlink "$dst")"
    if [[ "$cur" == "$src" ]]; then
      echo "  ✓ 已链接: $name → $src"
      return
    fi
    echo "  ↻ 替换旧软链: $name (旧: $cur)"
    rm "$dst"
  elif [[ -e "$dst" ]]; then
    echo "  📦 备份已存在的目录: $dst → $dst.bak.$TS"
    mv "$dst" "$dst.bak.$TS"
  fi

  ln -s "$src" "$dst"
  echo "  ✓ 链接: $name → $src"
}

echo "==> 安装 legal-research 技能序列到 $TARGET_DIR"

# 自有 skills
link_skill "$REPO_ROOT/skills/legal-research"   "legal-research"
link_skill "$REPO_ROOT/skills/yd-law-search"    "yd-law-search"
link_skill "$REPO_ROOT/skills/yd-case-search"   "yd-case-search"

# 外部 submodule（上游 repo 名是 china-lawyer-analyst，本地用 cs- 前缀）
EXT="$REPO_ROOT/external/cs-china-lawyer-analyst"
if [[ -d "$EXT" ]]; then
  link_skill "$EXT" "cs-china-lawyer-analyst"
else
  echo "  ⚠️  external/cs-china-lawyer-analyst 不存在；请先运行:"
  echo "      git submodule update --init --recursive"
fi

echo "==> 完成。验证: ls -la $TARGET_DIR"
