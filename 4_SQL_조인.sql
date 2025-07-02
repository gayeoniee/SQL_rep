-- JOIN의 종류

-- CROSS JOIN (카테지안프로덕트) N * M건의 결과셋이 생성
-- 체크해볼때 주로 사용

-- INNER JOIN (내부조인, EQUI JOIN, 동등조인) 데이터가 양쪽다 있는 것만 가져옴

-- OUTER JOIN 데이터가 있는 쪽 테이블 기준으로 출력
-- (LEFT, RIGHT, FULL OUTER)  N과 같은 결과셋

-- SELF JOIN  한개의 테이블을 두번 JOIN

-- ANSI
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