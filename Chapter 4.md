# 4장 - 집약

> 여러 개의 레코드를 한 개의 레코드로 집약하는 기능을 가짐


**집약 함수**
- COUNT
- SUM
- AVG
- MAX
- MIN



### 여러 개의 레코드를 한 개의 레코드로 집약

- 비집약 테이블에서 한 사람과 관련된 정보가 여러 개의 레코드에 분산되어 있다면 한 개의 레코드로 얻는 것이 편하다.
- 특정 처리에서 필요한 정보를 얻고 싶은 경우에도 모두 필드 수가 달라서 UNION으로 하나의 쿼리로 집약하는 것은 불가능하다.(안티 패턴)
- ***한 사람의 정보를 얻을 때 여러개의 쿼리가 아니라 한개면 충분하다.***



**CASE 식과 GROUP BY 응용**

- GROUP BY 구로 집약했을 때 SELECT 구에 입력할 수 있는 것은 다음 3가지 뿐이다.

1. 상수
2. GROUP BY 구에서 사용한 집약 키
3. 집약 함수



(1) 오류 발생 쿼리

```mysql
SELECT id,
		CASE WHEN data_type = 'A' THEN data_1 ELSE NULL END AS data_1,
		CASE WHEN data_type = 'A' THEN data_2 ELSE NULL END AS data_2,
		CASE WHEN data_type = 'B' THEN data_3 ELSE NULL END AS data_3,
		CASE WHEN data_type = 'B' THEN data_4 ELSE NULL END AS data_4,
		CASE WHEN data_type = 'B' THEN data_5 ELSE NULL END AS data_5,
		CASE WHEN data_type = 'C' THEN data_6 ELSE NULL END AS data_6
	FROM NonAggTbl
GROUP BY id;
```

- 위의 data_1~6은 위 3개에 모두 해당하지 않아서 오류가 발생한다. 그리고 SQL의 원리를 위배하는 것이기 때문에 집약 함수를 사용해 아래처럼 작성해야 한다.



(2) 모든 구현에서 작동하는 정답

```mysql
SELECT id,
		MAX(CASE WHEN data_type = 'A' THEN data_1 ELSE NULL END) AS data_1,
		MAX(CASE WHEN data_type = 'A' THEN data_2 ELSE NULL END) AS data_2,
		MAX(CASE WHEN data_type = 'B' THEN data_3 ELSE NULL END) AS data_3,
		MAX(CASE WHEN data_type = 'B' THEN data_4 ELSE NULL END) AS data_4,
		MAX(CASE WHEN data_type = 'B' THEN data_5 ELSE NULL END) AS data_5,
		MAX(CASE WHEN data_type = 'C' THEN data_6 ELSE NULL END) AS data_6
	FROM NonAggTbl
GROUP BY id;
```

- MAX 함수를 사용해 하나의 요소를 선택할 수 있다.
- 쿼리를 뷰로 만들어 저장할 수도 있다.



**집약, 해시, 정렬**

- GROUP BY 집약 조작에 **'해시'** 알고리즘을 사용한다. 경우에 따라서는 정렬을 사용하기도 한다.
- 해시가 정렬보다 빠르고 GROUP BY의 유일성이 높으면 더 효율적으로 작동한다.

- 정렬과 해시 모두 메모리를 많이 사용해 워킹 메모리가 확보되지 않으면 스왑이 발생한다.
- Oracle에서는 PGA 메모리 영역을 사용하는데, PGA 크기가 부족하면 일시 영역을 사용해 부족한 만큼 채우는 **TEMP 탈락** 현상이 일어난다.

- TEMP 탈락은 **성능이 극단적으로 떨어지기 때문에** 연산 대상 레코드 수가 많으면 **GROUP BY**나 **집약함수**를 사용하는 SQL에서 충분한 **성능 검증**을 해야 한다.



### 합쳐서 하나

| product_id | low_age | high_age | price |
| ---------- | ------- | -------- | ----- |
| 제품1      | 0       | 50       | 2000  |
| 제품1      | 51      | 100      | 3000  |
| 제품2      | 0       | 100      | 4200  |
| 제품3      | 0       | 20       | 500   |
| 제품3      | 31      | 70       | 800   |
| 제품3      | 71      | 100      | 1000  |
| 제품4      | 0       | 99       | 8900  |



Q. 0~100세까지 모든 연령이 가지고 놀 수 있는 제품을 구해야 할 때

- 제품3은 중간에 연속성이 깨진다. (21 ~ 30)
- 1개의 레코드로 전체를 커버하지 못해도 여러 개의 레코드를 조합해 커버할 수 있다면 -> **'합쳐서 하나'**

- 제품ID를 집약 키로 잡고 각 범위에 있는 **상수 개수를 모두 더한 합계가 101인 제품**을 선택하면 가능하다.

```mysql
SELECT product_id
	FROM PriceByAge
	GROUP BY product_id
HAVING SUM(high_age - low_age + 1) = 101;
```



A. *제품1, 제품2*





### 자르기

- GROUP BY 구는 '**자르기**'와 '**집약**'을 한꺼번에 수행하는 연산이다.



**파티션**

- GROUP BY 구로 잘라 만든 하나하나의 부분 집합
- 서로 중복되는 요소를 가지지 않는 부분 집합



- ex) 어린이(20세 미만), 성인(20~69세), 노인(70세 이상)

```mysql
SELECT CASE WHEN age < 20 THEN '어린이'
			WHEN age BETWEEN 20 AND 69 THEN '성인'
			WHEN age >= 70 THEN '노인'
			ELSE NULL END AS age_class,
		COUNT(*)
	FROM Persons
GROUP BY CASE WHEN age < 20 THEN '어린이'
              WHEN age BETWEEN 20 AND 69 THEN '성인'
              WHEN age >= 70 THEN '노인'
              ELSE NULL END;
```

- 자르기의 기준이 되는 키를 SELECT와 GROUP BY 구 모두 입력하는 것이 포인트다. **alias 별칭**을 GROUP BY에 사용할 수 있지만 표준에 없는 내용이다!



A.

| age_class | COUNT(*) |
| :-------: | :------: |
|  어린이   |    1     |
|   성인    |    6     |
|   노인    |    2     |





### PARTITION BY으로 자르기

- GROUP BY 구에서 집약 기능을 제외하고 자르는 기능만 남긴 것이다.
- CASE식, 계산 식을 사용한 복잡한 기준 사용 가능하다.
- 결과를 특정 column 기준으로 나누는 역할.



- ex) 같은 연령 등급에서 어린 순서로 순위를 매기는 코드

```mysql
SELECT name,
		age,
		CASE WHEN age < 20 THEN '어린이'
			 WHEN age BETWEEN 20 AND 69 THEN '성인'
			 WHEN age >= 70 THEN '노인'
			 ELSE NULL END AS age_class,
		RANK() OVER(PARTITION BY CASE WHEN age < 20 THEN '어린이'
                                      WHEN age BETWEEN 20 AND 69 THEN '성인'
                                      WHEN age >= 70 THEN '노인'
                                      ELSE NULL END
                    ORDER BY age) AS age_rank_in_class
        FROM Persons
ORDER BY age_class, age_rank_in_class;
```

- CASE식 사용
- 집약기능이 없어서 레코드가 모두 원래 형태로 나온다.



A. *레코드가 모두 나온다.*

| name     | age  | age_class | age_rank_in_class |
| -------- | ---- | --------- | ----------------- |
| Darwin   | 12   | 어린이    | 1                 |
| Adela    | 21   | 성인      | 1                 |
| Dawson   | 25   | 성인      | 2                 |
| Anderson | 30   | 성인      | 3                 |
| Donald   | 30   | 성인      | 3                 |

