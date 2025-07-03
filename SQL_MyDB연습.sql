USE my_db;

-- 사원들의 소속 부서 종류만 조회
SELECT DISTINCT DEPTNO FROM emp;

-- 급여가 2000이상 3000이하를 받는 사원 정보(부서번호, 이름, 직무, 급여)만 조회 , 결과집합 생성
SELECT DEPTNO, ENAME, JOB, SAL
FROM emp
WHERE SAL BETWEEN 2000 AND 3000;

-- 사원번호가 7902, 7788, 7566인  사원 정보(사원번호,부서번호, 이름, 직무 )만 조회
SELECT EMPNO, DEPTNO, ENAME, JOB
FROM emp
WHERE EMPNO IN (7902, 7788, 7566);

-- 사원 이름이 ‘A’로 시작하는  사원이름, 급여, 업무
SELECT ENAME, SAL, JOB
FROM emp
WHERE ENAME LIKE 'A%';

-- 사원 이름의 두번째 문자가 ‘A’인  모든 사원이름, 급여, 업무
SELECT ENAME, SAL, JOB
FROM emp
WHERE ENAME LIKE '_A%';

-- 사원 이름이 마지막 문자가 ‘N’인  사원이름, 급여, 업무 조회
SELECT ENAME, SAL, JOB
FROM emp
WHERE ENAME LIKE '%N';

-- 커미션을 받지 않는 사원이름, 급여, 업무, 커미션을  조회
SELECT ENAME, SAL, JOB, COMM 
FROM emp
WHERE COMM IS NULL;

-- 커미션이 NULL인 경우 0으로 SAL+COMM = TOTAL_SALARY 계산
SELECT ENAME, SAL
, IF (COMM IS NULL , SAL, SAL + COMM) AS TOTAL_SALARY
FROM emp;

-- 커미션을 받는 사원들의 커미션 평균
SELECT AVG(COMM)
FROM emp
WHERE COMM IS NOT NULL;

-- DEPTNO, JOB 별 급여합계, 급여평균, 총합계
SELECT DEPTNO, JOB
, SUM(SAL)
, AVG(SAL)
FROM emp
GROUP BY DEPTNO, JOB
WITH ROLLUP;

-- 외에 연습문제 출제해서 풀기

-- 1. 이름이 'S'로 시작하고, 급여가 2000 이상인 사원의 이름, 급여, 직무
SELECT ENAME, SAL, JOB
FROM emp
WHERE ENAME LIKE 'S%'
AND SAL >= 2000;

-- 2. 급여가 2000 미만 또는 3000 초과인 사원의 이름, 급여를 급여 내림차순으로 정렬해서
SELECT ENAME, SAL
FROM emp
WHERE SAL NOT BETWEEN 2000 AND 3000
ORDER BY SAL DESC;

-- 3. 커미션이 있는 사원의 이름, 커미션, 급여, 총수령액(SAL + COMM)을 TOTAL_SAL이라는 컬럼으로
SELECT ENAME, COMM, SAL
, SAL + COMM AS TOTAL_SAL
FROM emp
WHERE COMM IS NOT NULL;

-- 4. 사원번호가 7499, 7698, 7844 이고 직무가 'SALESMAN'인 사원들의 사원번호, 이름, 부서번호
SELECT EMPNO, ENAME, DEPTNO
FROM emp
WHERE EMPNO IN (7499, 7698, 7844)
AND JOB = 'SALESMAN'
;

-- 5. 부서별 평균 급여가 높은 순으로 정렬, 부서번호와 평균 급여를 출력
SELECT DEPTNO, AVG(SAL)
FROM emp
GROUP BY DEPTNO
ORDER BY AVG(SAL) DESC;

-- 6. 각 직무별 사원 수와 총 급여 합계, 총합도 함께 출력, 직무가 NULL인 경우 총합으로 바꿔서 출력
SELECT IF(GROUPING(JOB) = 1, '총합', JOB)
, COUNT(*)
, SUM(SAL)
FROM emp
GROUP BY JOB
WITH ROLLUP;

-- 7. 부서번호가 10 또는 30이고 커미션이 NULL인 사원의 이름, 부서번호, 급여, 직무
SELECT ENAME, DEPTNO, SAL, JOB
FROM emp
WHERE DEPTNO IN (10, 30)
AND COMM IS NULL;

-- 8. 사원 테이블에 존재하는 모든 직무의 종류를 중복 없이 정렬해서 출력
SELECT DISTINCT JOB
FROM emp
ORDER BY JOB;

-- 9. 1981년에 입사한 사원의 이름, 입사일, 부서번호
SELECT ENAME, HIREDATE, DEPTNO
FROM emp
WHERE YEAR(HIREDATE) = 1981;

-- 10. 오늘 기준으로 입사한 지 40년 이상 된 사원의 이름, 입사일, 근무 연수를 WORKED_YEARS로
SELECT ENAME, HIREDATE,
TIMESTAMPDIFF(YEAR, HIREDATE, CURDATE()) AS WORKED_YEARS
FROM emp
WHERE TIMESTAMPDIFF(YEAR, HIREDATE, CURDATE()) >= 40;

SELECT DEPTNO
     , AVG(IF(COMM IS NULL, SAL, SAL + COMM)) AS AVG_TOTAL
FROM emp
GROUP BY DEPTNO;

-- MY_DB 조인 연습
-- emp테이블에서 사원들의 이름, 급여와 급여 등급을 출력하는 SQL문 작성
SELECT ENAME, SAL, grade
FROM emp
LEFT JOIN salgrade
ON SAL BETWEEN losal AND hisal;

-- 사원번호, 사원이름, 관리자번호, 관리자이름을 조회
SELECT emp.EMPNO, emp.ENAME, emp.MGR, M.ENAME
FROM emp
LEFT JOIN emp AS M
ON emp.MGR=M.EMPNO;

-- 모든 사원에 대해서 사원번호와 이름, 부서번호, 부서이름을 조회
SELECT EMPNO, ENAME, emp.DEPTNO, DNAME
FROM emp
LEFT JOIN dept
ON emp.DEPTNO=dept.DEPTNO;

-- 모든 부서에 대해서 부서별로 소속 사원들의 정보를 출력
SELECT DNAME, emp.*
FROM dept
LEFT JOIN emp
ON dept.DEPTNO=emp.DEPTNO;

-- 모든 사원과 모든 부서 정보를 조인 결과로 생성
SELECT emp.*, dept.*
FROM emp
LEFT JOIN dept 
ON emp.DEPTNO = dept.DEPTNO
UNION
SELECT emp.*, dept.*
FROM emp
RIGHT JOIN dept 
ON emp.DEPTNO = dept.DEPTNO;

USE MY_DB;

-- 부서에 소속된 사원이 없어도 부서와 소속되지 않은 사원 출력
SELECT dept.DEPTNO, DNAME, ENAME
FROM dept
LEFT JOIN emp 
ON dept.DEPTNO = emp.DEPTNO
UNION
SELECT dept.DEPTNO, DNAME, ENAME
FROM dept
RIGHT JOIN emp 
ON dept.DEPTNO = emp.DEPTNO;

-- INSERT INTO emp
-- VALUES(9999, 'GOD', 'PRO', NULL, CURDATE(), 8000.00, NULL, NULL);

-- SELECT * FROM emp;
