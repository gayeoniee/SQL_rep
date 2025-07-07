-- 생성

CREATE DATABASE WNCAMP_CLASS;

USE WNCAMP_CLASS;

CREATE TABLE 학과
(
	학과번호 CHAR(2)
    , 학과명 VARCHAR(20)
    , 학과장명 VARCHAR(20)
);

INSERT INTO 학과
VALUES ('AA', '컴퓨터공학과', '배경민')
, ('BB', '소프트웨어학과', '김남준')
, ('CC', '디자인융합학과', '박선영');

CREATE TABLE 학생
(
	학번 CHAR(5)
    , 이름 VARCHAR(20)
    , 나이 INT
    , 연락처 int
    , 학과명 VARCHAR(20)
);
-- 나이(계속 변하니까), 연락처(문자로), 학과명(코드로 필요) 이상
DROP TABLE 학생;

CREATE TABLE 학생
(
	학번 CHAR(5)
    , 이름 VARCHAR(20)
    , 생일 DATE
    , 연락처 VARCHAR(20)
    , 학과번호 CHAR(2)
);

INSERT INTO 학생
VALUES ('S0001','이윤주','2020-01-30','01033334444','AA')
,('S0001','이승은','2021-02-23',NULL,'AA')
,('S0003','백재용','2018-03-31','01077778888','DD');

SELECT * FROM 학생;

CREATE TABLE 회원
(
	아이디 VARCHAR(20) PRIMARY KEY
    , 회원명 VARCHAR(20)
    , 키 INT 
    , 몸무게 INT
    , 체질량지수 DECIMAL(4, 1) AS (몸무게 / POWER(키 / 100, 2)) STORED
);

-- VIRTUAL 방식 : 조회할 때마다 바뀌는 값
-- STORED 방식 : 삽입이나 수정시만 계산

INSERT INTO 회원(아이디, 회원명, 키, 몸무게)
VALUES ('APPLE', '김사과', 178, 70);

SELECT * FROM 회원;

-- 수정 ALTER
-- 테이블 컬럼 추가(ADD), 삭제(DROP), 변경(MODIFY/CHANGE), 테이블이름(RENAME)

ALTER TABLE 학생 ADD 성별 CHAR(1);

ALTER TABLE 학생 MODIFY 성별 VARCHAR(2);
DESCRIBE 학생;

ALTER TABLE 학생 CHANGE 연락처 휴대폰번호 VARCHAR(20);

ALTER TABLE 학생 DROP 성별;

ALTER TABLE 학생 RENAME 졸업생;
DESCRIBE 졸업생;

-- TABLE 삭제
DROP TABLE 학과;
DROP TABLE 졸업생;

-- 제약조건 - 무결성
-- PRIMARY KEY = NOT NULL + UNIQUE
-- CHECK (조건에 맞는 것만 들어가게)
-- DEFAULT (값을 안넣어줘도 기본값이 있음)
-- FOREIGN KEY (다른 테이블과 연결)

USE WNCAMP_CLASS;
CREATE TABLE 학과
(
	학과번호 CHAR(2) PRIMARY KEY
    , 학과명 VARCHAR(20) NOT NULL
    , 학과장명 VARCHAR(20)
);

CREATE TABLE 학생
(
	학번 CHAR(5) PRIMARY KEY
    , 이름 VARCHAR(20) NOT NULL
    , 생일 DATE NOT NULL
    , 연락처 VARCHAR(20) UNIQUE
    , 학과번호 CHAR(2) REFERENCES 학과(학과번호)
    , 성별 CHAR(1) CHECK(성별 IN ('남', '여'))
    , 등록일 DATE DEFAULT(CURDATE())
    , FOREIGN KEY (학과번호) REFERENCES 학과(학과번호)
);

INSERT INTO 학과
VALUES ('AA', '컴퓨터공학과', '배경민');

INSERT INTO 학과
VALUES('AA', '소프트웨어학과', '김남준'); -- PRIMARY KEY 중복 에러

INSERT INTO 학과
VALUES ('CC', '디자인융합학과', '박선영');

INSERT INTO 학생(학번, 이름, 생일, 학과번호)
VALUES ('S0001','이윤주','2020-01-30','AA');

INSERT INTO 학생(이름, 생일, 학과번호)       -- PRIMARY KEY 입력 안해줘서 에러
VALUES ('S0001','이승은','2021-02-23','AA');
    
INSERT INTO 학생                        -- 학과 테이블에 DD라는 과 없음!
VALUES ('S0003','백재용','2018-03-31', 'DD');


CREATE TABLE 과목
(
	과목번호 CHAR(5) PRIMARY KEY
	,과목명 VARCHAR(20) NOT NULL
	,학점 INT NOT NULL CHECK(학점 BETWEEN 2 AND 4)
	,구분 VARCHAR(20) CHECK(구분 IN ('전공','교양','일반'))
);

INSERT INTO 과목(과목번호, 과목명, 구분)
VALUES ('C0001', '데이터베이스실습', '전공');     -- 학점 NOT NULL 이고 디폴트값 없음 에러

INSERT INTO 과목(과목번호, 과목명, 구분, 학점)
VALUES ('C0001', '데이터베이스실습', '전공', 3);

INSERT INTO 과목(과목번호, 과목명, 구분, 학점)
VALUES ('C0002', '데이터베이스 설계와 구축', '전공', 5);  -- 2~4 사이에 입력해야함 에러

INSERT INTO 과목(과목번호, 과목명, 구분, 학점)
VALUES ('C0002', '데이터베이스 설계와 구축', '전공', 4);

INSERT INTO 과목(과목번호, 과목명, 구분, 학점)
VALUES ('C0003', '데이터 분석', '전공', 3);



CREATE TABLE 수강_1
(
	수강년도 CHAR(4) NOT NULL
	,수강학기 VARCHAR(20) NOT NULL CHECK(수강학기 IN ('1학기','2학기','여름학기','겨울학기'))
	,학번 CHAR(5) NOT NULL
	,과목번호 CHAR(5) NOT NULL
	,성적 NUMERIC(3,1) CHECK(성적 BETWEEN 0 AND 4.5)
	,PRIMARY KEY(수강년도, 수강학기, 학번, 과목번호)
	,FOREIGN KEY (학번) REFERENCES 학생(학번)
	,FOREIGN KEY (과목번호) REFERENCES 과목(과목번호)
);
-- PRIMARY KEY를 많이 지정하여 (복합키) 사용하면 문제가 생길 수 있음
-- 쿼리 할때마다 키들을 계속 가지고 다녀야함
-- 그래서 대리키 라는 것을 사용

INSERT INTO  수강_1(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023', '1학기', 'S0001', 'C0001', 4.3);

INSERT INTO  수강_1(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023', '1학기', 'S0001', 'C0001', 4.5);        -- 기본키 중복

INSERT INTO  수강_1(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023', '1학기', 'S0001', 'C0002', 4.6);        -- 성적 범위 안맞음

INSERT INTO  수강_1(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023', '1학기', 'S0002', 'C0009', 4.3);      -- 과목번호가 과목에 없음 (외래키 에러)

SELECT * FROM 수강_1;


-- 수강_2 테이블 생성 -> 대리키
CREATE TABLE 수강_2
(
	수강번호 INT PRIMARY KEY AUTO_INCREMENT
    , 수강년도 CHAR(4) NOT NULL
	,수강학기 VARCHAR(20) NOT NULL CHECK(수강학기 IN ('1학기','2학기','여름학기','겨울학기'))
	,학번 CHAR(5) NOT NULL
	,과목번호 CHAR(5) NOT NULL
	,성적 NUMERIC(3,1) CHECK(성적 BETWEEN 0 AND 4.5)
	,FOREIGN KEY (학번) REFERENCES 학생(학번)
	,FOREIGN KEY (과목번호) REFERENCES 과목(과목번호)
);

INSERT INTO  수강_2(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023', '1학기', 'S0001', 'C0001', 4.3);

INSERT INTO  수강_2(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023', '1학기', 'S0001', 'C0001', 4.5);

INSERT INTO  수강_2(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023', '1학기', 'S0001', 'C0001', 4.3);

INSERT INTO  수강_2(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023', '1학기', 'S0001', 'C0001', 4.5);

SELECT * FROM 수강_2;

-- 대리키를 사용한다고 다 해결 되는 것은 아님
-- 대리키를 사용할 때는 -> 확인 필요!!

-- 제약조건의 삭제, 수정

ALTER TABLE 학생 ADD CONSTRAINT CHECK(학번 LIKE 'S%');
SELECT * FROM 학생;

INSERT INTO 학생
VALUES ('S0003','백재용','2018-03-31', '01033334444', 'BB', '남', DEFAULT);

ALTER TABLE 학생 DROP CONSTRAINT 연락처;

USE WNTRADE;

-- 제품 테이블의 재고 컬럼 '0보다 크거나 같아야 한다'
ALTER TABLE 제품 ADD CONSTRAINT CHECK(재고 >= 0);

-- 제품테이블 재고금액 컬럼 추가 '단가*재고' 자동 계산, 저장
ALTER TABLE 제품 ADD 재고금액 DECIMAL AS (단가*재고) STORED;

SHOW CREATE TABLE 주문세부;

-- 제품 레코드 삭제시 주문 세부 테이블의 관련 레코드도 함께 삭제되도록 주문 세부 테이블에 설정
ALTER TABLE 주문세부
ADD FOREIGN KEY (제품번호)
REFERENCES 제품(제품번호)
ON DELETE CASCADE;