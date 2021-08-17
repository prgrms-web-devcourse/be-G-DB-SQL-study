# 📌 3장. 정렬과 연산 

## # ORDER BY 정렬
> SELECT 명령의 ORDER 구를 사용하여 검색결과의 행 순서를 바꿀 수 있다. 
```sql
SELECT 열명 FROM 테이블명 WHERE 조건식 ORDER BY 열명

SELECT 열명 FROM 테이블명 WHERE 조건식 ORDER BY 열명 DESC -- 내림차순

SELECT 열명 FROM 테이블명 WHERE 조건식 ORDER BY 열명 ASC -- 오름차순 (기본)
```

- 검색 조건이 필요없는 경우에는 WHERE 구 생략
- `DESE`로 내림차순 정렬
- `ASC`로 오름차순 정렬
- 대소관계 
    - 수치형 데이터 : 숫자 크기
    - 날짜시간형 데이터 : 숫자 크기
    - 문자열형 데이터 : 사전식 순서
    - 만약, varchar(문자열형)의 데이터 1, 11, 2, 10 를 오름차순으로 정렬하면 1 → 10 → 11 → 2 
- ORDER BY 는 테이블에 영향을 주지 않음

**→ SELECT 명령은 데이터를 검색하는 명령으로 테이블의 데이터를 참조만 할 뿐, 변경하지 않는다.**

<br/>

---

## # 복수의 열을 지정해 정렬하기 
> 복수의 열을 지정하여 정렬할 수 있다.
```sql
SELECT 열명 FROM 테이블명 WHERE 조건식 
ORDER BY 열명1 [ACS|DESC], 열명2 [ACS|DESC] ...
```
→ 문장의 가독성을 높이기 위해서라도 가능한 한 정렬방법을 생략하지 말고 지정하도록 하자! 

<br/>

### # NULL 값 정렬 순서
- '특정 값보다 큰 값', 특정 값보다 작은 값'
- `MySQL` 의 경우 NULL 값을 가장 작은 값으로 취급하여 ASC에서는 가장 먼저, DESC에서는 가장 나중에

<br/>

---

## # 결과 행 제한하기 - LIMIT
> LIMIT 구로 결과 행 수를 제한할 수 있다.  
```sql
SELECT 열명 FROM 테이블명 (WHERE 조건식 ORDER BY 열명) LIMIT 행수 [OFFSET 시작행]
```
- LIMIT 구는 표준 SQL이 아니므로, MySQL과 PostgreSQL에서만! 
- LIMIT 구는 SELECT 명령의 마지막에 지정

<br/>

- SQL Server 에서는 `TOP` → ex. `SELECT TOP 3 * FROM 테이블명;`
- ORACLE 에서는 `ROWNUM` → ex. `SELECT * FROM 테이블명 WHERE ROWNUM <= 3;`

<br/>

### # OFFSET 지정 (페이지 나누기 기능)
```sql
SELECT 열명 FROM 테이블명 LIMIT 행수 OFFSET 위치
```

<br/>

---

## # 수치 연산

```sql
+ - * / % MOD
```

|연산자|연산|우선순위|
|:---:|:---:|:---:|
|+|덧셈|2|
|-|뺼셈|2|
|*|곱셈|1|
|/|나눗셈|1|
|%|나머지|1|

<br/>

### # SELECT 구에서 연산하기
```sql
SELECT 열명, 식1, 식2 ... FROM 테이블명
```

- ex. `SELECT *, price * quantity FROM 테이블명;`
- `price * quantity`와 같이 열 이름이 길고 알아보기 어려운 경우 별명을 불여 열명을 재지정!!
- 별명 예약어 **AS** 사용(생략 가능) / 한글로 지정할 경우 **더블쿼트(MySQL에서는 백쿼드)** 로 둘러싸기!
- 이름을 지정하는 경우 숫자로 시작되지 않도록!! 

```sql
SELECT *, price * quantity AS amount FROM 테이블명;

SELECT *, price * quantity `금액` FROM 테이블명;
```

<br/>

### # WHERE 구에서, ORDER BY 구에서 연산하기
- 데이터베이스 서버 내부에서 **WHERE 구 → SELECT 구 → ORDER BY 구**의 순서로 처리되기 때문에 
- SELECT 구에서 지정한 별명은 WHERE 구 안에서 사용할 수 ❌
- ORDER BY 구에서는 SELECT 구에서 지정한 별명을 사용할 수 ⭕️

<br/>

### # 함수 사용하여 연산하기
```sql
함수명(인수1, 인수2 ...)

ex.
    10 % 3 → 1
    MOD(10, 3) → 1  -- 나머지 함수
    ROUND(숫자, 반올림할 자릿수) -- 반올림 함수 
    TRUNCATE(숫자, 버릴 자릿수) -- 버림 함수   
```

<br/>

---

## # 문자열 연산
```sql
+ || CONCAT SUBSTRING TRIM CHARACTER_LENGTH
```

### # 문자열 결합 연산자
|연산자/함수|연산|데이터베이스|
|:---:|:---:|:---:|
|+|문자열 결합셈|SQL Server|
|\|\||문자열 결합|Oracle, PostgreSQL|
|CONCAT|문자열 결합|MySQL/|

### # SUBSTRING 함수
> 문자열의 일부분을 계산해서 반환해주는 함수 (문자열 추출)

### # TRIM 함수
> 문자열의 앞뒤로 여분의 스페이스가 있을 경우 이를 제거해주는 함수 (공백 제거)

### # CHARACTER_LENGTH 함수
> 문자열의 길이를 계산해 돌려주는 함수

<br/>

---

## # 날짜 연산
```sql
CURRENT_TIMESTAMP CURRENT_DATE INTERVAL
```
- 시스템 날짜 : `CURRENT_TIMESTAMP`
- 두 날짜 사이의 차이 : `DATADIFF('YYYY-MM-DD',YYYY-MM-DD')` 
 
 <br/>

---

## # CASE 문으로 데이터 변환하기 
```sql
CASE WHEN 조건식1 THEN 식1
    [ WHEN 조건식2 THEN 식2 ]
    [ ELSE 식3 ]
END
```
- 임의의 조건에 따라 독자적으로 변환 처리를 지정해 데이터를 변환하고 싶을 경우에 사용
- `WHAN` 절에는 참과 거짓을 반환하는 조건식, 해당 조건을 만족하여 참이 되는 경우 `THAN` 절에 기술
- 그 어떤 조건식도 만족하지 못한 경우에는 `ELSE` 절에 기술 
- 검색 CASE ↔️ 단순 CASE


<br/>

### # CASE를 사용할 경우 주의사항

- `ELSE` 는 생략 → 'NULL' 로 반환되기 때문에 생략하지 않는 편이 낫다.
- `WHEN` 에 `NULL` 지정 → 단순 CASE 문으로는 NULL 값을 비교할 수 없다. 
- NULL 값을 반환하는 경우 `COALESCE` 함수 사용