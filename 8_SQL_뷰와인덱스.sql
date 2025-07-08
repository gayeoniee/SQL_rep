USE WNTRADE;

-- VIEW : 한 개 이상의 테이블을 기반으로 생성된 가상의 테이블
-- 뷰는 실제 데이터를 저장하지 않으며, 쿼리 실행 시점에 생성된 쿼리 결과를 가상의 테이블로 만들어서 제공


-- ‘여’ 사원에 대하여 사원의 이름, 집전화, 입사일, 주소, 성별을 보이는 뷰를 작성
CREATE OR REPLACE VIEW VIEW_사원_여
AS
SELECT 이름
, 집전화
, 입사일
, 주소
, 성별
FROM 사원
WHERE 성별='여';

SELECT * FROM VIEW_사원_여;

-- 제품 테이블, 주문세부 테이블을 조인하여 제품명과 주문수량합을 보이는 뷰를 작성
CREATE OR REPLACE VIEW VIEW_제품별주문수량합
AS
SELECT 제품명
, SUM(주문수량) AS 주문수량합
FROM 제품
INNER JOIN 주문세부
ON 제품.제품번호=주문세부.제품번호
GROUP BY 제품명;

SELECT * FROM VIEW_제품별주문수량합;

INSERT INTO view_제품별주문수량합
VALUES('단짠 새우깡', 250);  -- 본 테이블 생각하기!!!

DESCRIBE VIEW_제품별주문수량합;
SHOW CREATE VIEW VIEW_제품별주문수량합;

-- ‘view_사원_여’ 뷰를 사용하여 다음 레코드를 삽입
-- 이름: 황여름, 전화번호: (02)587-4989, 입사일: 2023-02-10, 주소: 서울시 강남구 청담동 23-5, 성별: 여
INSERT INTO VIEW_사원_여(이름, 집전화, 입사일, 주소, 성별)
VALUES('황여름', '(02)587-4989', '2023-02-10', '서울시 강남구 청담동 23-5', '여');  
-- 뷰가 참조하는 테이블의 NOT NULL 컬럼은 INSERT 시 반드시 값이 들어가야 함 (사원번호)

-- => 
CREATE OR REPLACE VIEW VIEW_사원_여
AS
SELECT 사원번호
, 이름
, 집전화
, 입사일
, 주소
, 성별
FROM 사원
WHERE 성별='여';

SELECT * FROM VIEW_사원_여;
INSERT INTO VIEW_사원_여(사원번호, 이름, 집전화, 입사일, 주소, 성별)
VALUES('E12', '황여름', '(02)587-4989', '2023-02-10', '서울시 강남구 청담동 23-5', '여');

SELECT * FROM 사원
WHERE 사원번호='E12';



-- WITH CHECK OPTION
-- 특정 뷰에 대해 INSERT 또는 UPDATE 작업을 수행할 때 뷰에서 조건을 만족하지 않는 행이 생성되거나 수정되는 것을 방지
-- 데이터의 일관성을 보장하기 위한 제약조건
INSERT INTO VIEW_사원_여(사원번호, 이름, 집전화, 입사일, 주소, 성별)
VALUES('E13', '강겨울', '(02)587-4989', '2023-02-10', '서울시 강남구 청담동 23-5', '남');   -- 들어는 감
  
SELECT * FROM VIEW_사원_여;  -- 보이지는 않음

-- WITH CHECK OPTION
CREATE OR REPLACE VIEW VIEW_사원_여
AS
SELECT 사원번호
, 이름
, 집전화
, 입사일
, 주소
, 성별
FROM 사원
WHERE 성별='여'
WITH CHECK OPTION;

INSERT INTO VIEW_사원_여(사원번호, 이름, 집전화, 입사일, 주소, 성별)
VALUES('E14', '박수박', '(02)587-4989', '2023-02-10', '서울시 강남구 청담동 23-5', '남');  -- ERROR

-- 뷰 : 가상의 테이블, 데이터 복제 x, 쿼리만 저장 -> CREATE, ALTER, DROP, SELECT
-- WITH CHECK OPTION 생각하기!

-- 인덱스 
-- 기본인덱스(1 PK) + 보조인덱스(0~N)
-- 복합인덱스 : 2개 이상의 컬럼으로 구성, AND로 연결, %로 시작하면 안됨

-- 테이블에 걸려있는 인덱스를 확인
SHOW INDEX FROM 사원;

USE 분석실습;

-- 국가별/상품별 총 판매량 뷰 생성
CREATE OR REPLACE VIEW view_sales_summary
AS
SELECT country, stockcode, SUM(quantity) AS total_quantity
, SUM(quantity*unitprice) AS total_sales
FROM sales
GROUP BY country, stockcode;

SELECT * FROM view_sales_summary
WHERE country='United Kingdom';

SHOW INDEX FROM sales;

-- 고객 ID, 인보이스 날짜 기준으로 인덱스 생성!
CREATE INDEX idx_customer_date
ON sales (customerid, invoicedate);

EXPLAIN ANALYZE
SELECT * FROM sales
WHERE customerid=17850 AND invoicedate >= '2010-12-01';

EXPLAIN ANALYZE
SELECT * FROM sales        -- %로 시작하면 인덱스 못탐
WHERE customerid LIKE '%17850' AND invoicedate >= '2010-12-01';

ALTER TABLE sales DROP INDEX idx_customer_date;   -- 인덱스 있을 때, 없을 때 비교

USE WNCAMP_CLASS;

CREATE TABLE 날씨
(
	년도 INT
    , 월 INT
    , 일 INT
    , 도시 VARCHAR(20)
    , 기온 NUMERIC(3, 1)
    , 습도 INT
    , PRIMARY KEY(년도, 월, 일, 도시)
    , INDEX 기온인덱스(기온)
    , INDEX 도시인덱스(도시)
);

INSERT INTO 날씨
VALUES
('2022', '12', '13', '서울', 19.8, 17),
('2023', '11', '25', '부산', 18.2, 22),
('2022', '10', '07', '인천', 23.5, 19),
('2023', '03', '17', '대구', 15.1, 21),
('2024', '06', '29', '서울', 20.4, 25),
('2022', '07', '03', '부산', 17.6, 18),
('2024', '08', '15', '인천', 24.3, 20),
('2023', '09', '12', '대구', 21.7, 23),
('2022', '04', '10', '서울', 16.9, 20),
('2024', '05', '21', '부산', 22.1, 19),
('2023', '12', '14', '인천', 19.3, 21),
('2022', '01', '18', '대구', 13.7, 18),
('2024', '03', '19', '서울', 21.2, 22),
('2022', '02', '11', '부산', 16.5, 20),
('2023', '10', '27', '인천', 23.0, 24),
('2024', '07', '09', '대구', 18.8, 17),
('2022', '06', '30', '서울', 20.6, 23),
('2023', '08', '05', '부산', 17.3, 19),
('2024', '09', '14', '인천', 24.7, 20),
('2022', '03', '08', '대구', 15.9, 21),
('2023', '05', '15', '서울', 22.4, 18),
('2024', '12', '20', '부산', 19.1, 22),
('2022', '11', '22', '인천', 23.2, 20),
('2023', '02', '04', '대구', 14.8, 17),
('2024', '04', '07', '서울', 20.3, 19),
('2022', '08', '26', '부산', 16.1, 24),
('2023', '06', '16', '인천', 22.8, 21),
('2024', '01', '23', '대구', 13.9, 18),
('2022', '09', '28', '서울', 18.7, 23),
('2023', '07', '02', '부산', 17.8, 19),
('2025', '01', '03', '서울', 2.3, 60),
('2025', '01', '15', '부산', 5.8, 55),
('2025', '02', '10', '대구', 4.7, 48),
('2025', '02', '20', '인천', 1.5, 63),
('2025', '03', '05', '광주', 9.2, 50),
('2025', '03', '22', '대전', 11.3, 46),
('2025', '04', '08', '울산', 14.1, 40),
('2025', '04', '18', '수원', 15.7, 43),
('2025', '05', '09', '성남', 18.6, 45),
('2025', '05', '21', '청주', 19.3, 47),
('2025', '06', '03', '전주', 21.5, 50),
('2025', '06', '27', '강릉', 23.2, 58),
('2025', '07', '12', '춘천', 25.1, 65),
('2025', '07', '25', '포항', 26.7, 68),
('2025', '08', '06', '제주', 28.4, 70),
('2025', '08', '19', '여수', 27.9, 75),
('2025', '09', '01', '창원', 24.3, 60),
('2025', '09', '15', '안산', 22.7, 55),
('2025', '10', '10', '경산', 18.9, 48),
('2025', '11', '05', '김해', 13.6, 52);

SHOW INDEX FROM 날씨;

EXPLAIN ANALYZE
SELECT * FROM 날씨
WHERE 년도=2023 OR 월=6;

EXPLAIN ANALYZE
SELECT * FROM 날씨
WHERE 년도=2023 AND 일 > 1;

EXPLAIN ANALYZE
SELECT * FROM 날씨
WHERE 기온 BETWEEN 10 AND 20;

EXPLAIN ANALYZE SELECT * FROM 날씨 FORCE INDEX (기온인덱스) WHERE 기온 BETWEEN 10 AND 20;
-- ????
EXPLAIN ANALYZE
SELECT 기온 FROM 날씨
WHERE 기온 BETWEEN 10 AND 20;

EXPLAIN ANALYZE
SELECT * FROM 날씨
WHERE 도시 LIKE '서울%';

EXPLAIN ANALYZE
SELECT * FROM 날씨
WHERE 기온 >= 10 AND 습도 >= 20;


EXPLAIN ANALYZE
SELECT * FROM 날씨
WHERE 년도=2023 AND 월=6 AND 도시 LIKE '서울%';


USE 분석실습;
-- 인덱스 테스트
SHOW INDEX FROM sales;
SELECT * FROM sales;
EXPLAIN ANALYZE
SELECT * FROM sales
WHERE customerid = '21035'
AND (invoicedate BETWEEN '2010-12-01' AND '2010-12-02');