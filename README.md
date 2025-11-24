# Studyspot Infra Repository

- 이 저장소는 Studyspot 프로젝트의 운영 환경(Infrastructure)을 코드 기반으로 관리하기 위한 레포지토리입니다.  
- Docker Compose, Nginx, Monitoring Stack, 환경 변수 템플릿 등이 포함됩니다.



## 📁 Repository Structure

```
studyspot-infra/
├── docker/               # docker-compose.yml 및 관련 설정
├── nginx/                # studyspot.conf 등 Nginx 설정파일
├── monitoring/           # Grafana / Loki / Promtail 등 모니터링 구성
├── env-template/         # .env.template 자동 생성용 템플릿 저장
├── script/               # 유틸리티 스크립트 (env 변환, 빌드 자동화 등)
├── .gitignore
├── README.md
```



## 🔧 Infrastructure Overview

### 1. Docker Compose 기반 서비스 운영
- Backend / Frontend / Hoppscotch / MinIO / Monitoring 등 컨테이너 기반 운영
- 환경별 설정 분리(dev/prod)
- 이미지 빌드 및 컨테이너 라이프사이클 관리

### 2. Reverse Proxy – Nginx
- 운영 도메인 HTTPS 적용 및 Certbot 자동 인증서 갱신
- frontend, backend, storage, hoppscotch 등 여러 서비스 라우팅 처리
- Static File Server (임시/별도 서비스) 구성 가능

### 3. Monitoring Stack
- Loki + Promtail + Grafana 기반의 로그 모니터링
- Alertmanager 연동 가능 (WIP)
- Docker 내부 로그 수집 자동화



## 🔐 Environment Variables

-  `.env`는 로컬 전용 파일로 git에 **절대 업로드하지 않는다**  
- `.env.template`는 팀 공유용 템플릿이며, 값은 비워둔 채 키만 제공한다.

### 자동 템플릿 생성 스크립트
```
./script/generate-env-template.sh
```

### 기능
- `.env`를 읽고  
- 값을 `"비문"`으로 치환하여  
- `env-template/.env.template`로 저장



## 🚀 Deployment Flow

1. 로컬 `.env` 업데이트  
2. docker-compose 설정 변경  
3. Nginx 설정 변경 시 `studyspot.conf` 수정  
4. 서버에 push → pull 후 적용  
5. 서비스 재시작  
```
docker compose down && docker compose up -d
sudo systemctl reload nginx
```



## 📌 운영 규칙

### 1. 모든 Infra 변경은 Git으로 버전 관리
- docker-compose.yml
- studyspot.conf
- .env.template
- 스크립트

### 2. 실제 서버의 `.env`는 팀 내부 공유 금지
- 필요 시 secure channel로만 공유

### 3. 주요 변경 시엔 반드시 PR 생성
- 문서 반영
- 테스트 후 배포



## 📝 Changelog (작성 예시)

### 2025-11-25
- MinIO 신규 구성 추가
- Nginx reverse proxy 개선
- .env → .env.template 자동변환 스크립트 추가



## ✨ Notes
- 이 레포지토리는 장기적으로 Studyspot 서비스의 "Infra as Code" 기반 운영을 목표로 합니다.  
- 모든 환경 구성은 코드화하여 투명성과 유지보수성을 확보합니다.
