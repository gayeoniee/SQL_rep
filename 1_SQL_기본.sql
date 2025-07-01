SHOW DATABASES;
USE WORLD;
SHOW TABLES;

USE WNTRADE;
SHOW TABLES;

-- 얘네는 뭐가 다를까...
DESCRIBE 고객;
SHOW COLUMNS FROM 고객;

-- 셀렉션 명령: 테이블에서 행 단위로 추출

SELECT COUNT(*) FROM 고객;  -- 93건
SELECT COUNT(*) FROM 주문;  -- 830건

SELECT *
FROM information_schema.tables  -- information_schema.tables: 현재 서버에 있는 모든 데이터베이스의 테이블 정보가 들어있는 시스템 테이블
WHERE table_schema = 'WNTRADE';  -- WHERE table_schema = 'WNTRADE': 데이터베이스 이름이 WNTRADE인 테이블만 필터링

-- 프로젝션 연산 
SELECT 고객번호, 고객회사명, 담당자명 -- 어떤 컬럼인지 지정
FROM 고객
WHERE 담당자명='이은광';  -- 셀렉션 연산

-- 쿼리 연습 해보기
SELECT 제품명, 단가, 재고
FROM 제품
WHERE 단가 > 3000;

SELECT COUNT(*)
FROM 제품
WHERE 단가 > 3000;

SELECT 제품번호, 주문수량
FROM 주문세부;

SELECT 제품번호
FROM 주문세부
WHERE 주문수량 >= 10;

-- 프로젝션 >> 컬럼 ALIAS, 연산식, 함수
SELECT 고객회사명
, 담당자명 AS 이름
, 담당자직위 AS 직위  -- AS: 컬럼 별명
, 마일리지
, 마일리지 * 1.1 AS '인상된 마일리지'
FROM 고객
WHERE 마일리지 > 100000
ORDER BY 4 DESC; -- 마일리지(숫자)로 정렬 (DEFAULT = ASC), 별명을 써도 되고, 인덱스번호로 해도 OK

SELECT 고객번호, 담당자명, 도시, 마일리지
FROM 고객
WHERE 도시='서울특별시'
ORDER BY 마일리지 DESC;

SELECT *
FROM 고객
LIMIT 3;   -- 1행 ~ 3행

-- 마일리지 TOP3 고객
SELECT *
FROM 고객
ORDER BY 마일리지 DESC
LIMIT 3;

SELECT DISTINCT 도시
FROM 고객;

-- DISTINCT: 전체 데이터중 하나만 꺼내는것! -> 다 읽고 하나씩 추출하는 거라 많이 쓰는 건 성능 저하의 가능성이 있음

SELECT DISTINCT 지역
FROM 사원;

-- 1. SQL 문에서는 대소문자 구분이 없다 - 키워드, 객체명 모두
-- 2. ; 으로 문장 구분
-- 3. 가독성을 위해 줄을 맞춰 쓴다
-- 4. 일단적으로 키워드는 대문자, 객체명은 소문자로 입력한다
-- 5. 프로젝션에서 지정한 컬럼의 순서가 출력의 순서이다

-- 연산자
-- 산술, 비교, 논리, 집합
SELECT 2 + 3 AS 더하기
, 2 - 5 AS 빼기
, 23 / 5
, 23 DIV 5
, 23 % 5
, 23 MOD 5;

SELECT 2 < 3
, 3 != 3
, 2 <> 2;

-- 담당자가 대표이사가 아닌 고객의 모든 정보
SELECT * FROM 고객
WHERE 담당자직위 != '대표 이사';

-- 주문일이 2020-3-16일 이전의 주문목록
SELECT * FROM 주문
WHERE 주문일 < '2020-03-16';

-- 논리연산자: AND, OR, NOT
SELECT * FROM 고객
WHERE (도시 = '부산광역시') AND (마일리지 < 1000);

-- 서울이거나, 마일리지가 5000이상
SELECT * FROM 고객
WHERE (도시 = '서울특별시') OR (마일리지 >= 5000);

-- 서울이 아닌 고객
SELECT * FROM 고객
WHERE 도시 != '서울특별시';

-- 서울이 아닌데 마일리지가 5000이상
SELECT * FROM 고객
WHERE (도시 != '서울특별시') AND (마일리지 >= 5000);

-- 서울, 부산인 마일리지 5000이상
SELECT * FROM 고객
WHERE (도시 = '서울특별시' OR 도시 = '부산광역시')
AND 마일리지 >= 5000;

SELECT * FROM 고객
WHERE 도시 IN ('서울특별시', '부산광역시')
AND 마일리지 >= 5000;

-- 집합 연산: 합집합 UNION, UNIONALL
SELECT 고객회사명, 주소, 도시 FROM 고객
WHERE 도시 = '부산광역시'
AND 마일리지 >= 5000
UNION
SELECT 고객회사명, 주소, 도시 FROM 고객
WHERE 도시 = '서울특별시'
AND 마일리지 >= 5000
ORDER BY 1;

SELECT 도시 FROM 고객
-- UNION ALL  -- 103건
UNION  -- 30건
SELECT 도시 FROM 사원;

-- 교집합 INTERSECTION
SELECT DISTINCT 도시 FROM 고객
WHERE 도시 IN (
	SELECT DISTINCT 도시 FROM 사원
);

-- 여집합 EXCEPT
SELECT 도시 FROM 고객
WHERE 도시 NOT IN (
	SELECT DISTINCT 도시 FROM 사원
);

-- 합집합: 컬럼수와 컬럼의 데이터타입이 일치해야 함
-- 정렬: 전체 쿼리 바깥에서 ORDER BY

-- IS NULL 연산자
-- NULL: 값 없음 0이나 ''이 아님!
SELECT * FROM 고객
-- WHERE 지역 = '';  -- 66 ROW
WHERE 지역 IS NULL;  -- 0 ROW

-- 상사가 없는 사원
SELECT * FROM 사원
WHERE 상사번호 IS NULL;  -- 0

SELECT * FROM 사원
WHERE 상사번호 = '';  -- 2

-- NULL 인지 ''인지 구분 필요함


UPDATE 고객
SET 지역 = NULL
WHERE 지역 = '';

SELECT * FROM 고객
WHERE 지역 IS NULL;

-- IN: OR 연산
-- BETWEEN ~ AND ~: AND 연산, 범위 지정

-- IN 의 적용 -> 여러개중에 1개만 만족해도 참
SELECT 고객번호, 담당자명, 담당자직위
FROM 고객
WHERE 담당자직위 IN ('영업 과장', '마케팅 과장');

-- 서울, 부천, 부산에 사는 사원
SELECT * FROM 사원
WHERE 도시 IN ('서울특별시', '부천시', '부산광역시');

-- A1, A2 부서의 사원
SELECT * FROM 사원
WHERE 부서번호 IN ('A1', 'A2');

-- 마일리지가 100000점 이상, 200000점 이하인 고객의 담당자명, 마일리지
SELECT 담당자명, 마일리지
FROM 고객
WHERE 마일리지 BETWEEN 100000 AND 200000;
-- 수치형이나 날짜형 가능!

-- 주문이 특정 한달동안 발생한 목록 (6월)
SELECT * FROM 주문
WHERE 주문일 BETWEEN '2020-06-01' AND '2020-06-30';

-- 마일리지가 7000대 ~ 9000대인 고객 추출
SELECT * FROM 고객
WHERE 마일리지 BETWEEN 7000 AND 9999;

-- LIKE 연산자 %, _ (밑줄)
SELECT * FROM 고객
WHERE 도시 LIKE '%광역시';

SELECT * FROM 고객
WHERE 도시 LIKE '__시';

SELECT * FROM 고객
WHERE 지역 LIKE '%남도';

-- 도시가 광역시 이면서 고객번호 두번째 글자 또는 세번째 글자가 c인 고객
SELECT * FROM 고객
WHERE 도시 LIKE '%광역시'
AND (고객번호 LIKE '_C%' OR 고객번호 LIKE '__C%');  -- 괄호 중요!

-- WRAP UP

-- 전화번호가 45로 끝나는 고객
SELECT * FROM 고객
WHERE 전화번호 LIKE '%45';

-- 전화번호 중에 45가 있는 고객
SELECT * FROM 고객
WHERE 전화번호 LIKE '%45%';

-- 서울에 사는 고객 중 마일리지 15000점 이상, 2만점 이하인 고객
SELECT * FROM 고객
WHERE (도시='서울특별시') AND (마일리지 BETWEEN 15000 AND 20000);

-- 고객의 거주 지역, 도시를 1개씩 보이기 > 지역순, 동일지역은 도시순으로 출력
SELECT DISTINCT 지역, 도시
FROM 고객
ORDER BY 지역, 도시;

-- 춘천시, 과천시, 광명시 고객중 직위에 이사/사원이 있는 고객
SELECT * FROM 고객
WHERE 도시 IN ('춘천시', '과천시', '광명시')
AND (
    담당자직위 LIKE '%이사%' OR
    담당자직위 LIKE '%사원%'
  );

-- 광역시, 특별시가 아닌 고객중 마일리지가 많은 상위 고객 3명 
SELECT * FROM 고객
WHERE 도시 NOT LIKE '%광역시'
AND 도시 NOT LIKE '%특별시'
ORDER BY 마일리지 DESC
LIMIT 3;

-- 지역 값이 있는 고객, 담당자직위가 대표이사인 고객을 제외하고 출력
SELECT * FROM 고객
WHERE 지역 IS NULL
AND 담당자직위 != '대표 이사';
