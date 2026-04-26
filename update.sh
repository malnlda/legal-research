#!/usr/bin/env bash
# 拉取本仓库与 submodule 的上游更新。
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

echo "==> git pull"
git pull --ff-only

echo "==> git submodule update --remote --recursive"
git submodule update --init --remote --recursive

echo "==> 提示: 如要锁版本（推荐），请显式 commit submodule 当前指针:"
echo "    git add external/cs-china-lawyer-analyst && git commit -m 'chore: bump submodule'"
echo "==> 完成。无需重跑 install.sh，软链会自动跟随仓库变化。"
