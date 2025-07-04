-- SELECT 1개 테이블
-- JOIN 2개 이상의 테이블

-- 서브쿼리 (내부쿼리)
/*
SELECT *
FROM 테이블
WHERE 컬럼=(서브쿼리);
*/

-- 서브쿼리 : 한 문장 안에 1개의 메인 쿼리와 1개 이상의 서브쿼리가 있는 구조
-- 조인 : 1개의 쿼리문 안에 2개 이상의 테이블을 연결한 후 필요한 컬럼을 조회

-- 종류
-- 1. 서브쿼리가 반환하는 행의 개수 : 단일행, 복수행
-- 2. 서브쿼리의 위치에 따라 조건절(WHERE), FROM절, SELECT절
-- 3. 상관서브쿼리 : 메인쿼리와 서브쿼리 상관(컬럼)
-- 4. 반환하는 컬럼수 : 단일컬럼, 다중컬럼 서브쿼리

USE WNTRADE;

SELECT 고객회사명, 담당자명, 마일리지
FROM 고객
WHERE 마일리지 = (
	SELECT MAX(마일리지)
    FROM 고객
);

SELECT 고객.고객회사명, 고객.담당자명, 고객.마일리지
FROM 고객
LEFT JOIN 고객 AS B
ON 고객.마일리지 < B.마일리지
WHERE B.고객번호 IS NULL;

-- 주문번호 ‘H0250’을 주문한 고객에 대해 고객회사명과 담당자명을 보이시오
SELECT 고객번호, 고객회사명, 담당자명
FROM 고객
WHERE 고객번호=(  -- 서브쿼리: 단일행, 컬럼 1개  -> 하나인지 확인하기!
	SELECT 고객번호
    FROM 주문
    WHERE 주문번호='H0250'
);

-- ‘부산광역시’고객의 최소 마일리지보다 더 큰 마일리지를 가진 고객 정보를 보이시오
SELECT 고객회사명, 담당자명, 마일리지
FROM 고객
WHERE 마일리지 > (
	SELECT MIN(마일리지)
    FROM 고객
    WHERE 도시='부산광역시'
);


-- 복수행 서브쿼리 IN, ANY(최솟값과 비교), SOME, ALL(최대값과 비교), EXISTS(존재하면 참)
-- 서브쿼리의 결과가 여러 행

-- ‘부산광역시’ 고객이 주문한 주문건수
SELECT COUNT(*) AS 주문건수
FROM 주문
WHERE 고객번호 IN (
	SELECT 고객번호
    FROM 고객
    WHERE 도시='부산광역시'
    );
    
-- ‘부산광역시’ 전체 고객의 마일리지보다 마일리지가 큰 고객의 정보
SELECT 고객회사명, 담당자명, 마일리지
FROM 고객
WHERE 마일리지 > ALL(
	SELECT 마일리지
    FROM 고객
    WHERE 도시='부산광역시'
);

-- 각 지역의 어느 평균 마일리지보다도 마일리지가 큰 고객의 정보
SELECT 고객회사명, 담당자명, 마일리지
FROM 고객
WHERE 마일리지 > ALL(
	SELECT AVG(마일리지)
    FROM 고객
    GROUP BY 지역
    );
    
-- 한 번이라도 주문한 적이 있는 고객의 정보
SELECT 고객번호, 고객회사명
FROM 고객
WHERE EXISTS(
	SELECT 주문번호
    FROM 주문
    WHERE 고객번호=고객.고객번호  -- 상관 서브쿼리
    );
    
SELECT 고객번호, 고객회사명
FROM 고객
WHERE 고객번호 IN (
	SELECT 고객번호
    FROM 주문
    );
    
-- 위치 : WHERE에 존재하는 서브쿼리

-- GROUP BY의 조건절에 사용하는 서브쿼리
SELECT 도시, AVG(마일리지) AS 평균
FROM 고객
GROUP BY 도시
HAVING 평균 > (SELECT AVG(마일리지)
			FROM 고객
            );

-- FROM 절의 서브쿼리 : INLINE VIEW (SQL문 안에서 사용하는 가상의 테이블)
-- 별명이 필수! (테이블 명)
SELECT 도시, AVG(마일리지) AS 도시_평균
FROM 고객
GROUP BY 도시;

SELECT 고객회사명, 담당자명, 마일리지, 고객.도시
, 도시_평균, 도시_평균-마일리지 AS 차이
FROM 고객
JOIN (SELECT 도시, AVG(마일리지)  AS 도시_평균
		FROM 고객
		GROUP BY 도시) AS 요약
ON 고객.도시=요약.도시;

-- 사원별 상사의 이름 출력을 인라인뷰로 구현
SELECT A.이름 AS 사원명, B.이름 AS 상사명
FROM 사원 AS A
JOIN (SELECT 사원번호, 이름 FROM 사원) AS B
ON A.상사번호=B.사원번호;

-- 제품별 총 주문 수량과 재고 비교
SELECT 제품.제품명, 수량.총주문수량, 제품.재고
FROM 제품
LEFT JOIN (
    SELECT 제품번호, SUM(주문수량) AS 총주문수량
    FROM 주문세부
    GROUP BY 제품번호
) AS 수량
ON 제품.제품번호=수량.제품번호;

-- 고객별 가장 최근 주문일
SELECT 고객.고객회사명, 최근.가장최근주문일
FROM 고객
LEFT JOIN (
	SELECT 고객번호, MAX(주문일) AS 가장최근주문일
    FROM 주문
    GROUP BY 고객번호
) AS 최근
ON 고객.고객번호=최근.고객번호;

-- INLINE VIEW 는 JOIN과 비슷한 느낌
-- 테이블이 물리적으로 존재하는 것이냐, 가상 테이블이냐의 차이
-- 가져올게 많으면 JOIN을 쓰는 것이 좋음 (유지보수 관점에서 되도록이면 JOIN)

-- 스칼라 서브쿼리

SELECT 고객번호, (SELECT MAX(주문일)
				FROM 주문
				WHERE 주문.고객번호=고객.고객번호) AS 최근주문일
FROM 고객;

-- 고객별 총 주문건수 (스칼라)
EXPLAIN ANALYZE
SELECT 고객회사명, (SELECT COUNT(*)
				FROM 주문
                WHERE 주문.고객번호=고객.고객번호) AS 총주문건수
FROM 고객;

-- 조인
EXPLAIN ANALYZE
SELECT 고객회사명, COUNT(*) AS 총주문건수
FROM 고객
LEFT JOIN 주문
ON 주문.고객번호=고객.고객번호
GROUP BY 고객.고객번호;

-- 각 제품의 마지막 주문단가
SELECT 제품명, (SELECT 주문세부.단가
				FROM 주문세부
                JOIN 주문
                ON 주문.주문번호=주문세부.주문번호
                WHERE 주문세부.제품번호=제품.제품번호
                ORDER BY 주문일 DESC
                LIMIT 1) AS 마지막주문단가
FROM 제품;

-- 각 사원별 최대 주문수량
SELECT 이름, (SELECT MAX(주문수량)
			FROM 주문세부
            JOIN 주문
            ON 주문.주문번호=주문세부.주문번호
            WHERE 주문.사원번호=사원.사원번호) AS 최대주문수량
FROM 사원;

-- CTE : 임시테이블 정의, 쿼리 1개임!
WITH 도시요약 AS(
	SELECT 도시, AVG(마일리지) AS 도시평균
    FROM 고객
    GROUP BY 도시
)

SELECT 고객회사명, 고객.도시, 도시평균
FROM 고객
JOIN 도시요약
ON 고객.도시=도시요약.도시;

-- 다중컬럼 서브쿼리

-- 각 도시마다 최고 마일리지를 보유한 고객의 정보
SELECT 고객회사명, 도시, 마일리지
FROM 고객
WHERE (도시, 마일리지) IN (
	SELECT 도시, MAX(마일리지)
    FROM 고객
    GROUP BY 도시
);

SELECT 고객.고객회사명, 고객.도시, 고객.마일리지 AS 최고마일리지
FROM 고객
JOIN 고객 AS B
ON 고객.도시=B.도시
GROUP BY 고객.고객회사명, 고객.도시, 고객.마일리지
HAVING 고객.마일리지=MAX(B.마일리지);