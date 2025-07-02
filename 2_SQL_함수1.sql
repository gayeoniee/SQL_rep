USE WNTRADE;
SHOW TABLES;

-- 함수들(처리)을 DB단에서 하는게 효율적일지, 앱에서 하는게 효율적일지 고민 필요!
-- 연습을 하면서 함수들에 따라, 상황에 따라 어디서 하면 효과적일지를 생각하는게 필요함

-- 문자형 함수

SELECT CHAR_LENGTH('SQL')  -- CHAR_LENGTH( ) : 문자의 개수를 반환하는 함수
, LENGTH('SQL')            -- LENGTH( ) : 문자열에 할당된 바이트(Byte) 수를 반환하는 함수
, CHAR_LENGTH('안녕하세요')
, LENGTH('안녕하세요');

SELECT CONCAT('DREAMS', 'COME', 'TRUE')   -- CONCAT( ) : 문자열을 연결할 때 사용하는 함수
, CONCAT_WS('-', '2025', '07', '02');     -- CONCAT_WS( ) : 구분자와 함께 문자열을 연결할 때 사용하는 함수

SELECT LEFT('SQL 함수 연습', 3)   -- LEFT( ) : 문자열의 왼쪽부터 길이만큼 문자열을 반환하는 함수
, RIGHT('SQL 함수 연습', 5)       -- RIGHT( ) : 문자열의 오른쪽부터 길이만큼 문자열을 반환하는 함수
, SUBSTR('SQL 함수 연습', 3)      -- SUBSTR( ) : 지정한 위치로부터 길이만큼의 문자열을 반환하는 함수
, SUBSTR('SQL 함수 연습', 3, 4);

-- SUBSTRING_INDEX( ) : 지정한 구분자를 기준으로 문자열을 분리해서 가져올 때 사용하는 함수
SELECT SUBSTRING_INDEX('서울시 동작구 노량진로', ' ', 2)  -- 왼쪽부터 두번째 공백 이후 제거
, SUBSTRING_INDEX('서울시 동작구 노량진로', ' ', -2);     -- 오른쪽으로부터 두번째 공백 이전 제거

-- LPAD( )는 왼쪽에, RPAD( )는 오른쪽에 특정 문자를 채움
-- 지정한 길이에서 문자열을 제외한 빈칸을 특정 문자로 채울 때 사용하는 함수
SELECT LPAD('SQL', 10, '-')
, RPAD('SQL', 6, '=');

-- 공백을 제거할 때 사용하는 함수
SELECT LENGTH(LTRIM('    SQL   '))
, LENGTH(RTRIM('  SQL   '))
, LENGTH(TRIM('     SQL      '));

-- TRIM(BOTH/LEADING/TRAILING) : 문자열을 제거하고자 할 때
SELECT TRIM(BOTH 'abc' FROM 'abcSQLabc')
, TRIM(LEADING 'abc' FROM 'abcSQLabc')
, TRIM(TRAILING 'abc' FROM 'abcSQLabc');

SELECT FIELD('JAVA', 'SQL', 'JAVA', 'PYTHON')   -- 첫 매개변수인 'JAVA'의 위치, 찾는 문자열이 없으면 0을 반환
, FIND_IN_SET('JAVA', 'SQL,JAVA,PYTHON')        -- ,로 구분된 두번째 매개변수 중 JAVA의 위치
, INSTR('행복하게 살자', '행복')     -- 행복의 위치
, LOCATE('행복', '행복하게 살자');

-- ELT( ) : 지정한 위치에 있는 문자열을 반환하는 함수
SELECT ELT(2, 'SQL', 'JAVA', 'PYTHON');

-- REPEAT( ) : 문자열을 반복하고자 할 때 사용하는 함수
SELECT REPEAT('+', 3);

-- REPLACE( ) : 문자열의 일부를 다른 문자열로 대체하고자 할 때 사용하는 함수
SELECT REPLACE('010.1234.5678', '.', '-');

-- REVERSE( ) : 문자열을 거꾸로 뒤집을 때 사용하는 함수
SELECT REVERSE('GGGGGGGHHHHHH');

-- 숫자형 함수

-- CEILING( ) : 올림, FLOOR( ) : 버림, ROUND( ) : 지정한 위치에서 반올림, TRUNCATE( ) : 지정한 위치에서 버림 
SELECT CEILING(123.56)
, FLOOR(123.56)
, ROUND(123.56, 1)
, TRUNCATE(123.56, 1);

-- ABS( ) : 절댓값을 반환하는 함수, SIGN( ) : 양수의 경우 1, 음수의 경우 -1을 반환하는 함수
SELECT ABS(-20)
, SIGN(-20)
, SIGN(20);

-- POWER( ) : n제곱 값을 반환하는 함수, SQRT( ) : 제곱근 값을 반환하는 함수, RAND( ) : 0과 1사이 임의의 실수 값을 반환하는 함수
SELECT POWER(2, 4)
, SQRT(25)
, RAND()
, RAND(42)            -- RAND( ) 안에 시드(Seed)를 설정하면 매번 동일한 임의의 값을 얻을 수 있음
, ROUND(RAND() * 100);

-- 날짜 / 시간형 함수
-- NOW(), SYSDATE(), CURDATE() & CURTIME()
-- 현재 날짜와 시간 모두 가져오기 : 쿼리 시작시점 -> NOW()
--                           함수 시작시점 -> SYSDATE()
SELECT NOW()
, SYSDATE()
, CURDATE()
, CURTIME();

SELECT NOW() AS NOW_1
, SLEEP(3)
, NOW() AS NOW_2
, SYSDATE() AS SYS_1
, SLEEP(3)
, SYSDATE() AS SYS_2;

-- 값을 구분해서 반환하는 함수
SELECT YEAR(NOW()) AS 년
, QUARTER(NOW()) AS 분기
, MONTH(NOW()) AS 월
, DAY(NOW()) AS 일
, HOUR(NOW()) AS 시
, MINUTE(NOW()) AS 분
, SECOND(NOW()) AS 초;

-- 기간 반환 함수
SELECT NOW()
, DATEDIFF(NOW(), '2024-12-20')              -- (END, START)
, TIMESTAMPDIFF(YEAR, NOW(), '2027-12-20')   -- (START, END)
, TIMESTAMPDIFF(MONTH, NOW(), '2027-12-20');

SELECT NOW()
, LAST_DAY(NOW())   -- 이번달의 마지막 일자
, DAYOFYEAR(NOW())  -- 오늘이 올해의 몇번째 날인지
, MONTHNAME(NOW())  -- 이번 달 이름을 영문으로
, WEEKDAY('2025-07-01');   -- 요일 (월요일부터 0)

-- 태어난지 몇일 되었는지?
-- 1000일 기념일
-- 태어난 요일
SELECT DATEDIFF(NOW(), '2000-06-28') AS '며칠 살았는지'
, DATE_ADD('2000-06-28', INTERVAL 1000 DAY) AS '1000일 기념일'
, DAYNAME('2000-06-28') AS '태어난 요일';

-- 형변환 함수
-- CAST(): ANSI SQL, CONVERT(): MYSQL
SELECT CAST('1' AS UNSIGNED)
, CAST(2 AS CHAR(1))
, CONVERT('1', UNSIGNED)
, CONVERT(2, CHAR(1));

-- 제어 함수
-- IF()   : 조건식, 참일 때 값, 거짓일 때 값
SELECT IF(MONTHNAME(NOW()) = 'July', '이번달', '다른달');

-- IFNULL(1, 2) : 널처리 -> 널이면 2, 널이 아니면 1
SELECT 지역, IFNULL(지역, '미입력')
FROM 고객;

-- NULLIF() : 조건을 만족하면 NULL, 아니면 지정한 값
SELECT NULLIF(12*10, 120)
, NULLIF(12*10, 1200);

SELECT 고객번호, NULLIF(마일리지, 0) AS '유효마일리지'
FROM 고객;

-- CASE 문
/*
SELECT 컬럼명
CASE WHEN 조건1 THEN 결과1
	WHEN 조건2 THEN 결과2
END;
*/
-- 고객, 마일리지 1만점 이상 -> VIP, 5000점이상 -> GOLD, 1000점이상 -> SILVER, ELSE -> BRONZE
SELECT 고객번호, 고객회사명, 마일리지
, CASE 
	WHEN 마일리지 >= 10000 THEN 'VIP'
	WHEN 마일리지 >= 5000 THEN 'GOLD'
	WHEN 마일리지 >= 1000 THEN 'SILVER'
	ELSE 'BRONZE'
	END AS 등급
FROM 고객;

-- 주문금액 = 수량 * 단가, 할인금액 = 주문금액 * 할인율, 실주문금액 = 주문금액 - 할인금액
-- 주문세부 테이블
SELECT * FROM 주문세부;

-- 사원테이블에서 이름, 생일, 만나이, 입사일, 입사일수, 500일 기념일


-- 주문테이블에서 주문번호, 고객번호, 주문일, 주문년도, 분기, 월, 일, 요일, 한글로 요일