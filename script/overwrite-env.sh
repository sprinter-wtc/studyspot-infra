#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT_FILE="$SCRIPT_DIR/../env-template/.env"
OUTPUT_FILE="$SCRIPT_DIR/../env-template/.env.template"

if [ ! -f "$INPUT_FILE" ]; then
  echo "[ERROR] .env 파일이 없습니다."
  exit 1
fi

echo "[INFO] .env 내용을 비문으로 덮어씁니다..."

# 주석 유지 + key=value 패턴만 값 교체
awk '
  # 주석(#)으로 시작하면 그대로 출력
  /^[[:space:]]*#/ { print; next }

  # key=value 형식이면 value를 "비문"으로 변경
  /^[A-Za-z0-9_.-]+=.*$/ {
    split($0, kv, "=")
    key = kv[1]
    print key"=\"비문\""
    next
  }

  # 그 외는 그대로 출력
  { print }
' "$INPUT_FILE" > "$OUTPUT_FILE"

echo "[DONE] env-template/.env.template 생성 완료"