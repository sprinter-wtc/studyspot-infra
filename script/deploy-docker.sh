#!/bin/bash
set -e

###############################################
# 설정값
###############################################
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REMOTE_DIR="/home/sprinter/studyspot"

SERVER_USER="sprinter"
SERVER_HOST="studyspot.kr"
SSH_KEY="$SCRIPT_DIR/../.ssh/studyspot"

LOCAL_ENV="$SCRIPT_DIR/../env-template/.env"
LOCAL_COMPOSE="$SCRIPT_DIR/../docker/docker-compose.yml"

###############################################
# 서버로 파일 업로드
###############################################
echo "[1/4] Uploading docker-compose.yml..."
scp -i $SSH_KEY $LOCAL_COMPOSE $SERVER_USER@$SERVER_HOST:$REMOTE_DIR/docker-compose.yml

echo "[2/4] Uploading .env..."
scp -i $SSH_KEY $LOCAL_ENV $SERVER_USER@$SERVER_HOST:$REMOTE_DIR/.env

###############################################
# 서버에서 docker compose down/up 실행
###############################################
echo "[3/4] Running docker compose down..."
ssh -i $SSH_KEY $SERVER_USER@$SERVER_HOST "
  cd $REMOTE_DIR && \
  docker compose down
"

echo "[4/4] Running docker compose up -d..."
ssh -i $SSH_KEY $SERVER_USER@$SERVER_HOST "
  cd $REMOTE_DIR && \
  docker compose up -d
"

echo "배포 완료!"