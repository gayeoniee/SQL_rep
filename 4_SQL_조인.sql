USE WNTRADE;
SHOW TABLES;

-- 관계형 데이터베이스 : 관계연산 - 프로젝션, 셀렉션, 조인
-- JOIN의 종류 : 2개 이상의 테이블에서 데이터를 모아올 때

-- CROSS JOIN (카테지안프로덕트) N * M건의 결과셋이 생성
-- 체크해볼때 주로 사용

-- INNER JOIN (내부조인, EQUI JOIN, 동등조인) 데이터가 양쪽다 있는 것만 가져옴

-- OUTER JOIN 데이터가 있는 쪽 테이블 기준으로 출력
-- (LEFT, RIGHT, FULL OUTER)  N과 같은 결과셋

-- SELF JOIN  한개의 테이블을 두번 JOIN

-- ANSI (실습)
/*
SELECT *
FROM A
JOIN B
*/
-- NON-ANSI
/*
SELECT * 
FROM A, B
*/

-- CROSS JOIN
SELECT *
FROM 부서
CROSS JOIN 사원
WHERE 이름='이소미';

SELECT *
FROM 부서, 사원
WHERE 이름='이소미';

-- 고객, 제품 크로스 조인
SELECT *
FROM 고객
CROSS JOIN 제품
;

-- INNER JOIN
-- 가장 일반적인 조인 방식: 두 테이블에서 조건에 만족하는 행만 연결 추출
-- 연결 컬럼을 찾아서 매핑
/*
SELECT * 
FROM A
INNER JOIN B
ON 조건 (=)
*/

-- '이소미' 사원의 사원번호, 직위, 부서번호, 부서명
SELECT 사원번호, 직위, 사원.부서번호, 부서명
FROM 사원
INNER JOIN 부서
ON 사원.부서번호 = 부서.부서번호
WHERE 이름='이소미';


-- 주문세부, 제품 제품명을 연결
SELECT 주문번호, 주문세부.제품번호, 제품.제품명
FROM 주문세부
INNER JOIN 제품
ON 주문세부.제품번호 = 제품.제품번호;

-- 고객 회사들이 주문한 주문건수를 주문건수가 많은 순서대로 보이시오. 
-- 이때 고객 회사의 정보로는 고객번호, 담당자명, 고객회사명을 보이시오.
SELECT 고객.고객번호, 담당자명, 고객회사명
, COUNT(*) AS 주문건수
FROM 고객
INNER JOIN 주문
ON 고객.고객번호=주문.고객번호
GROUP BY 고객.고객번호, 담당자명, 고객회사명
ORDER BY 주문건수 DESC;

-- 고객별(고객번호, 담당자명, 고객회사명)로 주문금액 합을 보이되, 주문금액 합이 많은 순서대로
SELECT 고객.고객번호, 담당자명, 고객회사명
, SUM(주문수량 * 단가) AS '주문금액 합'
FROM 고객
INNER JOIN 주문
ON 고객.고객번호=주문.고객번호
INNER JOIN 주문세부
ON 주문.주문번호=주문세부.주문번호
GROUP BY 고객.고객번호, 담당자명, 고객회사명
ORDER BY SUM(주문수량 * 단가) DESC;

-- 고객 테이블과 마일리지등급 테이블을 크로스 조인하시오. 
-- 그 다음 고객 테이블에서 담당자가 ‘이은광’인 고객에 대하여 고객번호, 담당자명, 마일리지와 마일리지등급 테이블의 모든 컬럼을 보이시오.
SELECT 고객번호, 담당자명, 마일리지, 마일리지등급.*
FROM 고객
CROSS JOIN 마일리지등급
WHERE 담당자명='이은광';

-- 비동등조인 (같은 컬럼이 없음)
SELECT 고객번호, 담당자명, 마일리지, 마일리지등급.*
FROM 고객
INNER JOIN 마일리지등급
ON 마일리지 BETWEEN 하한마일리지 AND 상한마일리지
WHERE 담당자명='이은광';

-- 카테이안 프로덕트: 범위성 테이블과 나올 수 있는 모든 조합을 확인
-- INNER JOIN : 컬럼으로 연결된 테이블에서 매핑된 행의 컬럼을 가져올 때
-- OUTER JOIN : 기준 테이블의 결과를 유지하면서 매핑된 컬럼을 가져오려 할 때

-- OUTER JOIN
-- LEFT, RIGHT, 
-- FULL(MYSQL은 지원x)

-- 부서와 사원
SELECT 사원번호, 이름, 부서명
FROM 사원
JOIN 부서
ON 사원.부서번호=부서.부서번호
WHERE 성별='여';             -- 4 ROW

SELECT 사원번호, 이름, 부서명
FROM 사원
LEFT JOIN 부서
ON 사원.부서번호=부서.부서번호
WHERE 성별='여';             -- 5 ROW (부서가 없는 사람 포함)

-- 고객 기준으로 주문을 보고 싶음 (고객명, 주문번호, 주문금액)
SELECT 고객회사명, 주문.주문번호
, SUM(주문수량 * 단가) AS 주문금액
FROM 고객
LEFT JOIN 주문
ON 고객.고객번호=주문.고객번호
LEFT JOIN 주문세부
ON 주문.주문번호=주문세부.주문번호
GROUP BY 고객회사명, 주문.주문번호;

SELECT 고객.고객번호, 고객회사명
FROM 고객
LEFT JOIN 주문 ON 고객.고객번호 = 주문.고객번호
WHERE 주문.주문번호 IS NULL;

-- 사원이 없는 부서
SELECT 부서명, 사원번호
FROM 부서
LEFT JOIN 사원
ON 부서.부서번호=사원.부서번호
WHERE 사원.사원번호 IS NULL;

-- 부서가 없는 직원과 직원이 없는 부서 모두 출력
-- FULL OUTER JOIN
SELECT 사원번호, 직위, 사원.부서번호, 부서명
FROM 사원
LEFT JOIN 부서
ON 사원.부서번호=부서.부서번호
UNION
SELECT 사원번호, 직위, 사원.부서번호, 부서명
FROM 사원
RIGHT JOIN 부서
ON 사원.부서번호=부서.부서번호;

-- 주문, 고객 FULL OUTER JOIN
SELECT 고객.고객번호, 고객회사명, 주문.*
FROM 고객
LEFT JOIN 주문 ON 고객.고객번호 = 주문.고객번호
UNION
SELECT 고객.고객번호, 고객회사명, 주문.*
FROM 고객
RIGHT JOIN 주문 ON 고객.고객번호 = 주문.고객번호;

-- SELF JOIN
-- + INNER JOIN
SELECT 사원.이름, 사원.직위, 상사.이름 AS 상사이름
FROM 사원
INNER JOIN 사원 AS 상사
ON 사원.상사번호=상사.사원번호;

-- OUTER + SELF
-- 사원이름, 직위, 상사이름을 상사이름 순으로 정렬하여 나타내시오. 
-- 이때 상사가 없는 사원의 이름도 함께 보이시오.
SELECT 사원.이름, 사원.직위, 상사.이름 AS 상사이름
FROM 사원 AS 상사
RIGHT JOIN 사원 
ON 사원.상사번호=상사.사원번호
ORDER BY 상사.이름;

USE WNTRADE;
-- 입사일이 빠른 선배-후배 관계 찾기 (전 직원의 선후배 관계)
SELECT 선후배.이름 AS 사원이름, 선후배.입사일
, 선배.이름 AS 선배이름
, 후배.이름 AS 후배이름
FROM 사원 AS 선후배
LEFT JOIN 사원 AS 선배
ON 선배.입사일 < 선후배.입사일
LEFT JOIN 사원 AS 후배
ON 후배.입사일 > 선후배.입사일;

-- 점검 문제

-- 제품별로 주문수량 합, 주문금액 합
SELECT 제품명, SUM(주문수량), SUM(주문수량*제품.단가)
FROM 제품
INNER JOIN 주문세부
ON 제품.제품번호=주문세부.제품번호
GROUP BY 제품명;

-- 아이스크림 제품의 주문년도, 제품명별 주문수량 합
SELECT YEAR(주문일) AS 주문년도, 제품명, SUM(주문수량)
FROM 제품
INNER JOIN 주문세부
ON 제품.제품번호=주문세부.제품번호
LEFT JOIN 주문
ON 주문세부.주문번호=주문.주문번호
WHERE 제품명 LIKE '%아이스크림'
GROUP BY YEAR(주문일), 제품명;

-- 주문이 한번도 안된 제품도 포함한 제품별로 주문수량 합, 
SELECT 제품명, SUM(주문수량)
FROM 제품
LEFT JOIN 주문세부
ON 제품.제품번호=주문세부.제품번호
GROUP BY 제품명;

-- 고객회사 중 마일리지 등급이 A인 고객의 정보
SELECT 고객회사명, 마일리지, 마일리지등급.등급명 
FROM 고객
INNER JOIN 마일리지등급
ON 마일리지 BETWEEN 하한마일리지 AND 상한마일리지
WHERE 등급명='A';

