# 1단계: 기존 데이터베이스 삭제 및 생성 (로컬 전용)
로컬에서 테스트 중이므로, 에뮬레이터에 쌓인 데이터를 지우고 새로 만듭니다.

1. 로컬 데이터 폴더 삭제 프로젝트 폴더 안에 있는 .wrangler 폴더를 삭제하세요. (이 폴더를 지우면 로컬 DB 파일이 물리적으로 삭제됩니다.)

2. 스키마 파일(schema.sql) 작성 프로젝트 루트 폴더에 파일을 만들고 아래 내용을 복사해 넣으세요.

SQL

DROP TABLE IF EXISTS ChannelStats;
DROP TABLE IF EXISTS Channels;

CREATE TABLE Channels (
    id TEXT PRIMARY KEY,
    title TEXT,
    country TEXT,
    category TEXT,
    thumbnail TEXT
);

CREATE TABLE ChannelStats (
    channel_id TEXT,
    subs INTEGER,
    views INTEGER,
    rank_date DATE,
    PRIMARY KEY(channel_id, rank_date)
);


3. 로컬 DB에 테이블 생성 터미널에서 아래 명령어를 입력합니다.

Bash

npx wrangler d1 execute tube-db --local --file=./schema.sql


정상 실행 시 출력 메시지:

✔ Success! 2 commands executed. 라는 메시지가 나와야 합니다.

2. 테이블 생성 확인 (검증)
테이블이 정말로 만들어졌는지 확인하기 위해 아래 명령어를 입력해 보세요.

Bash

로컬 DB의 테이블 목록 조회

npx wrangler d1 execute tube-db --local --command="SELECT name FROM sqlite_master WHERE type='table';"

결과 확인: 목록에 Channels와 ChannelStats가 보여야 합니다. 만약 아무것도 나오지 않는다면 1번 단계에서 schema.sql 파일 경로가 틀렸거나 파일 내용이 비어 있을 수 있습니다.



# 2단계: 환경 설정 파일 확인

1. wrangler.toml (DB 바인딩) DB 이름(tube-db)과 코드 내의 이름(DB)이 일치해야 합니다.

Ini, TOML

name = "tube-trend-pro"

main = "src/index.js"

compatibility_date = "2026-01-12"

[[d1_databases]]

binding = "DB"

database_name = "tube-db"

database_id = "local-testing"

2. .dev.vars (API 키) 로컬 테스트 시 비밀번호 역할을 합니다. 반드시 루트 폴더에 만들어주세요.

Plaintext

YOUTUBE_API_KEYS=본인의_유튜브_API_키_입력

# 3단계: 소스코드 저장 (src/index.js)
제공해주신 코드를 src/index.js에 그대로 저장하세요.

주의: 코드 내에 CURRENT_DATE를 사용하므로, 수집 즉시 데이터가 보이기 위해서는 로컬 PC의 날짜와 서버 쿼리가 일치해야 합니다.

# 4단계: 로컬 테스트 및 데이터 수집 (핵심)
이제 서버를 실행하고 데이터를 채워넣는 단계입니다.

1. 로컬 서버 실행

Bash

npx wrangler dev --local

터미널에 뜨는 주소(예: http://localhost:8787)를 브라우저로 엽니다.

2. 국가별 데이터 수집 (영국, 브라질 포함) 처음 접속하면 데이터가 아무것도 없습니다. 아래 순서로 진행하세요.

영국 수집: 메뉴에서 United Kingdom(GB) 선택 → Sync Data 클릭 → "GB data synchronization complete!" 알림 확인.

브라질 수집: 메뉴에서 Brazil(BR) 선택 → Sync Data 클릭.

한국 수집: 메뉴에서 South Korea(KR) 선택 → Sync Data 클릭.



# 꿀팁: DB에 데이터가 들어갔는지 직접 확인하기
서버를 띄워둔 상태에서 새 터미널을 열고 아래 명령어를 입력해 보세요. 데이터가 실제로 찍힌다면 UI(화면) 코드의 문제이고, 안 찍힌다면 수집 로직의 문제입니다.

Bash

로컬 DB에 채널이 몇 개 있는지 확인

npx wrangler d1 execute tube-db --local --command="SELECT count(*) FROM Channels;"

저장된 통계 데이터 확인

npx wrangler d1 execute tube-db --local --command="SELECT * FROM ChannelStats LIMIT 5;"




# 🔍 데이터가 정말 DB에 들어갔는지 확인하는 법
코드를 수정했는데도 안 보인다면, 실제로 Sync가 성공해서 DB에 데이터가 쌓였는지 터미널에서 직접 확인해야 합니다. wrangler dev를 실행 중인 상태에서 새 터미널을 열고 아래 명령어를 입력하세요.

1. 채널 정보가 들어있나? (결과에 채널 이름들이 나와야 함)

Bash

npx wrangler d1 execute tube-db --local --command="SELECT title, country FROM Channels LIMIT 10;"

2. 통계 데이터와 날짜가 기록되었나? (rank_date가 어떻게 찍혀있는지 확인)

Bash

npx wrangler d1 execute tube-db --local --command="SELECT * FROM ChannelStats LIMIT 10;"

💡 만약 위 명령어 결과가 "비어있음"으로 나온다면?
그것은 유튜브 API 호출 자체가 실패하고 있는 것입니다. .dev.vars 파일을 다시 점검해 주세요.

파일 위치: src 폴더 안이 아니라, wrangler.toml과 같은 최상위 폴더에 있어야 합니다.

형식: YOUTUBE_API_KEYS=AIza... (공백이나 따옴표 없이 입력)

재시작: .dev.vars를 수정했다면 npx wrangler dev를 껐다가 다시 켜야 적용됩니다.




# .dev.vars 파일 내용 정밀 점검
가장 흔한 실수는 키 주변에 공백이나 따옴표가 들어가는 것입니다. 파일을 열어 아래와 똑같은 형식인지 확인하세요.

위치: src 폴더 안이 아니라, wrangler.toml이 있는 최상위(루트) 폴더에 있어야 합니다.

형식: 따옴표(", ')나 쉼표 없이 키만 바로 적어야 합니다.

변수명: 코드에서 YOUTUBE_API_KEYS를 사용하므로 정확히 일치해야 합니다.

Plaintext

올바른 예 (공백 없음, 따옴표 없음)
YOUTUBE_API_KEYS=AIzaSy...자신의키문자열

틀린 예 (절대 안 됨)
YOUTUBE_API_KEYS = AIzaSy... (공백 포함)
YOUTUBE_API_KEYS="AIzaSy..." (따옴표 포함)
