#!/usr/bin/env bash
# 拉取本仓库与 submodule 的上游更新。
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

echo "==> git pull"
git pull --ff-only

echo "==> git submodule update --remote --recursive"
git submodule update --init --remote --recursive

echo "==> 修补 cs-china-lawyer-analyst/SKILL.md：确保 user_invocable: true"
SM="external/cs-china-lawyer-analyst/SKILL.md"
if [ -f "$SM" ] && ! grep -q "user_invocable" "$SM"; then
    python3 -c "
import sys
path = '$SM'
txt = open(path).read()
txt = txt.replace('\n---\n', '\nuser_invocable: true\n---\n', 1)
open(path, 'w').write(txt)
print('  已注入 user_invocable: true')
"
else
    echo "  (已存在或文件不在，跳过)"
fi

echo "==> 提示: 如要锁版本（推荐），请显式 commit submodule 当前指针:"
echo "    git add external/cs-china-lawyer-analyst && git commit -m 'chore: bump submodule'"
echo "==> 完成。无需重跑 install.sh，软链会自动跟随仓库变化。"
