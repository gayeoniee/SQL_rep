-- 매출 트렌드

SELECT * FROM sales;

-- 기간별 매출 현황
SELECT invoicedate
, SUM(unitprice * quantity) AS 매출액
, SUM(quantity) AS 주문수량
, COUNT(DISTINCT invoiceno) AS 주문건수
, COUNT(DISTINCT customerid) AS 주문고객수
FROM sales
GROUP BY invoicedate
ORDER BY invoicedate;

-- 국가별 매출 현황
SELECT country
, SUM(unitprice * quantity) AS 매출액
, SUM(quantity) AS 주문수량
, COUNT(DISTINCT invoiceno) AS 주문건수
, COUNT(DISTINCT customerid) AS 주문고객수
FROM sales
GROUP BY country;

-- 국가별 x 제품별 매출 현황
SELECT country
, stockcode
, SUM(unitprice * quantity) AS 매출액
, SUM(quantity) AS 주문수량
, COUNT(DISTINCT invoiceno) AS 주문건수
, COUNT(DISTINCT customerid) AS 주문고객수
FROM sales
GROUP BY country, stockcode;

-- 특정 제품 매출 현황 (stockcode='21615')
SELECT SUM(unitprice * quantity) AS 매출액
, SUM(quantity) AS 주문수량
, COUNT(DISTINCT invoiceno) AS 주문건수
, COUNT(DISTINCT customerid) AS 주문고객수
FROM sales
WHERE stockcode='21615';

-- 특정 제품의 기간별 매출 현황
SELECT invoicedate
, SUM(unitprice * quantity) AS 매출액
, SUM(quantity) AS 주문수량
, COUNT(DISTINCT invoiceno) AS 주문건수
, COUNT(DISTINCT customerid) AS 주문고객수
FROM sales
WHERE stockcode IN ('21615', '21731')
GROUP BY invoicedate;

-- 이벤트 효과 분석
SELECT CASE WHEN invoicedate BETWEEN '2011-09-10' AND '2011-09-25' THEN '이벤트 기간'
WHEN invoicedate BETWEEN '2011-08-10' AND '2011-08-25' THEN '이벤트 비교기간(전월동기간)'
END AS 기간구분
, SUM(unitprice*quantity) AS 매출액
, SUM(quantity) AS 주문수량
, COUNT(DISTINCT invoiceno) AS 주문건수
, COUNT(DISTINCT customerid) AS 주문고객수
FROM sales
WHERE invoicedate BETWEEN '2011-09-10' AND '2011-09-25'
OR invoicedate BETWEEN '2011-08-10' AND '2011-08-25'
GROUP BY CASE WHEN invoicedate BETWEEN '2011-09-10' AND '2011-09-25' THEN '이벤트 기간'
WHEN invoicedate BETWEEN '2011-08-10' AND '2011-08-25' THEN '이벤트 비교기간(전월동기간)'
END;

-- 이벤트는 효과적이었음!

-- 이벤트 제품 효과 분석 (시기에 대한 비교)
SELECT CASE WHEN invoicedate BETWEEN '2011-09-10' AND '2011-09-25' THEN '이벤트 기간'
WHEN invoicedate BETWEEN '2011-08-10' AND '2011-08-25' THEN '이벤트 비교기간(전월동기간)'
END AS 기간구분
, SUM(unitprice*quantity) AS 매출액
, SUM(quantity) AS 주문수량
, COUNT(DISTINCT invoiceno) AS 주문건수
, COUNT(DISTINCT customerid) AS 주문고객수
FROM sales
WHERE (invoicedate BETWEEN '2011-09-10' AND '2011-09-25'
OR invoicedate BETWEEN '2011-08-10' AND '2011-08-25')
AND stockcode IN ('17012A', '17012C', '17012', '17084N')
GROUP BY CASE WHEN invoicedate BETWEEN '2011-09-10' AND '2011-09-25' THEN '이벤트 기간'
WHEN invoicedate BETWEEN '2011-08-10' AND '2011-08-25' THEN '이벤트 비교기간(전월동기간)'
END;


SELECT * FROM customer;
-- 특정제품 구매 고객 정보
-- 2010년 12월 1일부터 2010년 12월 10일까지 '21730', '21615'를 구매한 고객
-- 고객ID, 이름, 성별, 생년월일, 가입일자, 등급, 가입채널
SELECT DISTINCT customerid
, CONCAT(last_name, first_name)
, gd, birth_dt, entr_dt, grade, sign_up_ch
FROM sales
LEFT JOIN customer
ON sales.customerid = customer.mem_no
WHERE stockcode IN ('21730', '21615')
AND invoicedate BETWEEN '2010-12-01' AND '2010-12-10';

-- 미구매 고객 정보(구매 이력)
SELECT CASE WHEN customerid IS NULL THEN mem_no END AS non_purchaser
, mem_no, last_name, first_name, invoiceno, stockcode
, quantity, invoicedate, unitprice, customerid
FROM customer
LEFT JOIN sales
ON customer.mem_no=sales.customerid
ORDER BY non_purchaser DESC;

USE 분석실습;

# 고객수
SELECT 
  COUNT(DISTINCT IF(customerid IS NULL, mem_no, NULL)) AS non_purchaser,
  COUNT(DISTINCT mem_no) AS total_customers
FROM customer
LEFT JOIN sales
  ON mem_no = customerid;

-- 고객 상품 구매 패턴 파악

-- A 브랜드 매장의 매출 평균 지표 
-- ATV : 한번 주문할 때 구매하는 총 금액 (매출액/주문건수)
-- AMV : 한명의 고객이 주문하는 금액 (매출액/주문고객수)
-- Avg.Frq : 한명의 고객이 주문하는 횟수 (주문건수/주문고객수)
-- Avg.Units : 한번 주문할 때 구매하는 총개수 (주문수량/주문건수)
SELECT SUM(unitprice*quantity) AS 매출액
, SUM(quantity) AS 주문수량
, COUNT(DISTINCT invoiceno) AS 주문건수
, COUNT(DISTINCT customerid) AS 주문고객수
, SUM(unitprice*quantity) / COUNT(DISTINCT invoiceno) AS ATV
, SUM(unitprice*quantity) / COUNT(DISTINCT customerid) AS AMV
, COUNT(DISTINCT invoiceno)*1.00 / COUNT(DISTINCT customerid)*1.00 AS AvgFrq
, SUM(quantity)*1.00 / COUNT(DISTINCT invoiceno)*1.00 AS AvgUnits
FROM sales;

-- 1.00을 곱해주는 이유는 실수로 보여지게 하려고!

-- 연도별, 월별 매출 평균 지표 파악
SELECT YEAR(invoicedate) AS 연도
, MONTH(invoicedate) AS 월
, SUM(unitprice*quantity) AS 매출액
, SUM(quantity) AS 주문수량
, COUNT(DISTINCT invoiceno) AS 주문건수
, COUNT(DISTINCT customerid) AS 주문고객수
, SUM(unitprice*quantity) / COUNT(DISTINCT invoiceno) AS ATV
, SUM(unitprice*quantity) / COUNT(DISTINCT customerid) AS AMV
, COUNT(DISTINCT invoiceno)*1.00 / COUNT(DISTINCT customerid)*1.00 AS AvgFrq
, SUM(quantity)*1.00 / COUNT(DISTINCT invoiceno)*1.00 AS AvgUnits
FROM sales
GROUP BY  YEAR(invoicedate), MONTH(invoicedate)
ORDER BY 1, 2;

-- 베스트셀링 상품 확인

-- 2011년에 가장 많이 판매된 제품 TOP10의 정보
SELECT stockcode, description
, SUM(quantity) AS qty
FROM sales
WHERE YEAR(invoicedate) = '2011'
GROUP BY stockcode, description
ORDER BY qty DESC
LIMIT 10;

-- 국가별 베스트셀링 상품 확인
-- 국가별로 가장 많이 판매된 제품 순으로 실적

SELECT RANK() OVER (PARTITION BY country ORDER BY SUM(quantity) DESC) AS rnk
, country, stockcode, description, SUM(quantity) AS qty
FROM sales
GROUP BY country, stockcode, description
ORDER BY 2, 1;

-- 20대 여성 고객의 베스트셀링(TOP 10) 상품 확인
SELECT RANK() OVER (ORDER BY SUM(quantity) DESC) AS rnk
, stockcode, description, SUM(quantity)
FROM sales
LEFT JOIN customer
ON sales.customerid=customer.mem_no
WHERE customer.gd = 'F'
AND 2023 - YEAR(birth_dt) BETWEEN '20' AND '29'
GROUP BY stockcode, description
LIMIT 10;

-- 장바구니 분석
-- 특정제품과 함께 가장 많이 구매한 제품 확인

-- '20725'와 함께 가장 많이 구매한 제품 TOP 10

-- 1. '20725'를 구매한 거래내역 확인
SELECT DISTINCT invoiceno
FROM sales
WHERE stockcode='20725';

-- 2. 1단계에서 확인한 거래내역 중 '20725'를 제외하고 구매한 제품 확인
SELECT invoiceno
FROM sales
WHERE stockcode <> '20725'
  AND invoiceno IN (
    SELECT invoiceno
    FROM sales
    WHERE stockcode = '20725'
)
GROUP BY invoiceno;


-- 3. 특정제품과 함께 구매한 제품의 주문수량을 구하고 주문수량이 높은 순서대로 상위 10개 나열
SELECT stockcode, description, SUM(quantity) AS total_quantity
FROM sales
WHERE invoiceno IN (
    SELECT DISTINCT invoiceno
    FROM sales
    WHERE stockcode = '20725'
)
AND stockcode <> '20725'
GROUP BY stockcode, description
ORDER BY total_quantity DESC
LIMIT 10;


-- 위에서 LUNCH가 포함되는 제품은 제외하고 싶음
SELECT stockcode, description, SUM(quantity) AS total_quantity
FROM sales
WHERE invoiceno IN (
    SELECT DISTINCT invoiceno
    FROM sales
    WHERE stockcode = '20725'
)
AND stockcode <> '20725'
AND description NOT LIKE '%LUNCH%'
GROUP BY stockcode, description
ORDER BY SUM(quantity) DESC
LIMIT 10;

-- 재구매 지표

-- 방법1 : 고객별로 구매 일수를 세는 방법
-- 방법2 : 고객별로 구매한 일수에 순서를 매기는 방법

-- 구매일수 카운팅
WITH repurchaser AS (
  SELECT customerid
  FROM sales
  WHERE customerid <> ''
  GROUP BY customerid
  HAVING COUNT(DISTINCT invoicedate) >= 2
)
SELECT COUNT(*) AS repurchaser_count
FROM repurchaser;

USE 분석실습;

-- 구매한 일자에 순서 매기기
-- '21088'의 재구매 고객수와 구매일자 순서 확인
WITH repurchaser AS (
  SELECT customerid
  , DENSE_RANK() OVER (PARTITION BY customerid ORDER BY invoicedate) AS rnk
  FROM sales
  WHERE customerid <> ''
  AND stockcode='21088'
)
SELECT COUNT(DISTINCT customerid) AS repurchaser_count
FROM repurchaser
WHERE rnk = 2;

-- DENSE_RANK()
-- 동일한 값에는 같은 순위를 부여하고 다음 순위는 그 이전 순위에서 건너뛰지 않고 바로 이어지는 순위 함수

-- 리텐션 : 고객이 주기적으로 방문해 서비스를 꾸준이 이용하는지 -> 유지에 관련된 지표
-- 2010년 구매 이력 고객들의 2011년 유지율 확인
-- 2010년에 구매한 고객들 중 2011년 구매 고객

SELECT COUNT(*) AS retention_customer_count
FROM (
  SELECT DISTINCT customerid
  FROM sales
  WHERE invoicedate BETWEEN '2010-01-01' AND '2010-12-31'
    AND customerid IS NOT NULL AND customerid <> ''
) AS s1
WHERE customerid IN (
  SELECT DISTINCT customerid
  FROM sales
  WHERE invoicedate BETWEEN '2011-01-01' AND '2011-12-31'
    AND customerid IS NOT NULL AND customerid <> ''
);

-- 고객별 재구매까지의 구매기간 확인
-- 1. 고객별 제품 구매 순서 정하기
WITH a AS (
  SELECT customerid, invoicedate
  FROM sales
  WHERE customerid <> ''
  GROUP BY customerid, invoicedate
)
SELECT customerid, invoicedate
, DENSE_RANK() OVER (PARTITION BY customerid ORDER BY invoicedate) AS date_no
FROM a;

-- 2. 1에서 확인한 순서를 바탕으로 첫구매와 재구매기간 확인
WITH a AS (
  SELECT customerid, invoicedate,
         DENSE_RANK() OVER (PARTITION BY customerid ORDER BY invoicedate) AS date_no
  FROM (
    SELECT DISTINCT customerid, invoicedate
    FROM sales
    WHERE customerid <> ''
  ) AS sub
)
SELECT a.customerid, a.invoicedate, a.date_no
, b.customerid, b.invoicedate, b.date_no
FROM a
INNER JOIN a AS b
ON a.customerid=b.customerid
AND a.date_no+1 = b.date_no
WHERE a.date_no = 1;

-- 3. 첫구매와 재구매 기간의 차이 계산
WITH a AS (
  SELECT customerid, invoicedate,
         DENSE_RANK() OVER (PARTITION BY customerid ORDER BY invoicedate) AS date_no
  FROM (
    SELECT DISTINCT customerid, invoicedate
    FROM sales
    WHERE customerid <> ''
  ) AS sub
)
SELECT a.customerid, a.invoicedate, a.date_no
, b.customerid, b.invoicedate, b.date_no
, DATEDIFF(b.invoicedate, a.invoicedate) AS purchase_period
FROM a
INNER JOIN a AS b
ON a.customerid=b.customerid
AND a.date_no+1 = b.date_no
WHERE a.date_no = 1;

-- 구매기간 차이 일수에 대한 평균 지표 구하기
WITH a AS (
  SELECT customerid, invoicedate,
         DENSE_RANK() OVER (PARTITION BY customerid ORDER BY invoicedate) AS date_no
  FROM (
    SELECT DISTINCT customerid, invoicedate
    FROM sales
    WHERE customerid <> ''
  ) AS sub
)
SELECT avg(DATEDIFF(b.invoicedate, a.invoicedate)) AS avg_purchase_period
FROM a
INNER JOIN a AS b
ON a.customerid=b.customerid
AND a.date_no+1 = b.date_no
WHERE a.date_no = 1;

-- 첫 고객은 구매 이후 다음 구매까지 평균 63일이 걸림