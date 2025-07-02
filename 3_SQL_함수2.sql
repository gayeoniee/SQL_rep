USE WNTRADE;
SHOW TABLES;

-- 집계함수
-- COUNT()
SELECT COUNT(*)
, COUNT(고객번호)
, COUNT(도시)
, COUNT(지역)
FROM 고객;

SELECT SUM(마일리지)
, MIN(마일리지)
, MAX(마일리지)
, AVG(마일리지)
FROM 고객;      -- 결과행이 1개로 축약

-- 서울 특별시 고객의 마일리지 합계
SELECT SUM(마일리지)
FROM 고객
WHERE 도시 = '서울특별시';  -- 조건부 집계

-- 그룹별 집계(소계): 컬럼의 값을 범주로 하여 집계
-- GROUP BY
SELECT 도시
, COUNT(*) AS 고객수
, AVG(마일리지) AS '평균 마일리지'
FROM 고객
GROUP BY 도시;

SELECT 담당자직위, 도시
, COUNT(*) AS 고객수
, AVG(마일리지) AS '평균 마일리지'
FROM 고객
GROUP BY 담당자직위, 도시
ORDER BY 담당자직위, 도시;

-- 집계 결과에 조건부 출력
-- HAVING
SELECT 도시
, COUNT(*) AS 고객수
, AVG(마일리지) AS '평균 마일리지'
FROM 고객
GROUP BY 도시
HAVING 고객수 >= 5;

-- WHERE : 셀렉션의 조건 -> GROUP BY 이전에 실행
-- HAVING : GROUP BY한 집계에 거는 조건, 기준 미달인 경우 제외시키기 위해 사용

-- 고객번호가 ‘T’로 시작하는 고객에 대해 도시별로 묶어서 고객의 마일리지 합을 구하시오. 
-- 이때 마일리지 합이 1,000점 이상인 레코드만 보이시오
SELECT 도시
, SUM(마일리지)
FROM 고객
WHERE 고객번호 LIKE 'T%'
GROUP BY 도시
HAVING SUM(마일리지) >= 1000;

SELECT 제품번호, AVG(주문수량)
FROM 주문세부
WHERE 주문수량 >= 30
GROUP BY 제품번호
HAVING AVG(주문수량) > 50;

-- SQL의 실행 순서
/*
SELECT           5번
FROM             1번
WHERE            2번
GROUP BY         3번
HAVING           4번
ORDER BY         6번
*/

-- WITH ROLLUP : 전체 총계
SELECT 도시
, COUNT(*) AS 고객수
, AVG(마일리지) AS '평균 마일리지'
FROM 고객
GROUP BY 도시
WITH ROLLUP;

-- 고객번호가 ‘T’로 시작하는 고객에 대해 도시별로 묶어서 고객의 마일리지 합을 구하시오. 
-- 총계를 출력
SELECT 도시
, SUM(마일리지)
FROM 고객
WHERE 고객번호 LIKE 'T%'
GROUP BY 도시
WITH ROLLUP;

-- 여기서도 조건을 주고싶을 때
SELECT 도시, 합계
FROM(SELECT 도시, SUM(마일리지) AS 합계
	FROM 고객
	WHERE 고객번호 LIKE 'T%'
	GROUP BY 도시
	WITH ROLLUP) AS 그룹
WHERE 도시 IS NULL OR 합계 >= 1000;

-- 의도에 맞게 조건 먼저, 롤업 나중에
SELECT 도시, SUM(합계)
FROM (
  SELECT 도시, SUM(마일리지) AS 합계 
  FROM 고객
  WHERE 고객번호 LIKE 'T%'
  GROUP BY 도시
  HAVING SUM(마일리지) >= 1000
) AS 그룹
GROUP BY 도시 WITH ROLLUP;

-- 담당자직위가 ‘대표 이사’인 고객에 대하여 지역별로 묶어서 고객수를 보이고, 전체 고객수도 함께 보이시오
SELECT 지역
, COUNT(*) AS '고객수'
FROM 고객
WHERE 담당자직위 = '대표 이사'
GROUP BY 지역
WITH ROLLUP;

-- 담당자직위에 '마케팅'이 들어간 고객
-- 고객 (담당자직위, 도시)별 고객수를 보이시오
-- 담당자직위별 고객수와 전체 고객수 조회
SELECT 담당자직위, 도시
, COUNT(*) AS '고객수'
FROM 고객
WHERE 담당자직위 LIKE '%마케팅%'
GROUP BY 담당자직위, 도시
WITH ROLLUP;

-- GROUPING() ROLLUP의 결과 생성한 행은 1, 그룹행은 0
SELECT 지역
, IF (GROUPING(지역) = 1, '합계행', 지역) AS 도시명
, COUNT(*) AS 고객수
, GROUPING(지역) AS 구분
FROM 고객
WHERE 담당자직위 = '대표 이사'
GROUP BY 지역 WITH ROLLUP;

-- GROUP_CONCAT()
SELECT GROUP_CONCAT(고객회사명)
FROM 고객;

SELECT GROUP_CONCAT(DISTINCT 지역)
FROM 고객;

-- 성별에 따른 사원수, NULL -> 총 사원수를 출력 
SELECT
IF (GROUPING(성별) = 1, '총 사원수', 성별) AS 성별
, COUNT(*) AS 사원수
FROM 사원
GROUP BY 성별
WITH ROLLUP;

-- 주문년도별 주문건수
SELECT YEAR(주문일) AS 주문년도
, COUNT(*) AS 주문건수
FROM 주문
GROUP BY YEAR(주문일);

-- 주문년도별, 분기별, 전체주문건수 추가
SELECT YEAR(주문일) AS 주문년도
, QUARTER(주문일) AS 분기
, COUNT(*) AS 주문건수
FROM 주문
GROUP BY YEAR(주문일), QUARTER(주문일)
WITH ROLLUP;

SELECT
  IF(GROUPING(주문년도) = 1, '전체주문건수', 주문년도) AS 주문년도
  , IF(GROUPING(분기) = 1, 
     IF(GROUPING(주문년도) = 1, '-', '연도별 합계'), 분기) AS 분기
  , COUNT(*) AS 주문건수
FROM (
  SELECT YEAR(주문일) AS 주문년도, QUARTER(주문일) AS 분기
  FROM 주문
) AS 주문
GROUP BY 주문년도, 분기 WITH ROLLUP;

-- 주문내역에서 월별 발송지연건 
SELECT MONTHNAME(주문일) AS 주문월
, COUNT(*) AS 발송지연건
FROM 주문
WHERE 요청일 < 발송일
GROUP BY MONTHNAME(주문일)
WITH ROLLUP;

-- 아이스크림 제품별 재고합
SELECT IF(GROUPING(제품명) = 1, '전체 재고합', 제품명) AS 제품명
, SUM(재고) AS 재고합
FROM 제품
WHERE 제품명 LIKE '%아이스크림'
GROUP BY 제품명
WITH ROLLUP;

-- 고객구분(VIP,일반)에 따른 고객수, 평균 마일리지, 총합
SELECT IF(마일리지 > 10000, 'VIP', '일반') AS 고객구분
, COUNT(*) AS 고객수
, AVG(마일리지) AS 평균마일리지
FROM 고객
GROUP BY 고객구분
WITH ROLLUP;
