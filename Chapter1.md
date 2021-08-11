## DBMS 아키텍처

> 아키텍처 : SQL 구문 -> DBMS(쿼리 평가 엔진 -> *.매니저)

![책뿌수기 - SQL 레벨업-1 - Jaejin&#39;s blog](https://jaejin0me.github.io/posts102_1.jpg)

1. 쿼리 평가 엔진
   - 입력받은 SQL 구문 분석, 어떤 순서로 기억장치의 데이터에 접근할 지 결정.
   - *실행 계획 : 이때 결정되는 기획*
   - 계획을 세우고 실행한다!
   - DBMS의 핵심 기능으로 성능 관점에서 제일 중요함



2. 버퍼 매니저
   - *버퍼 : 특별한 용도로 사용하는 메모리 영역*
   - 버퍼를 관리하고 디스크 용량 매니저와 함께 연동되어 작동



3. 디스크 용량 매니저
   - 어디에 어떻게 데이터를 저장할지 관리하고, 데이터의 읽고 쓰기를 제어함.



4. 트랜잭션 매니저와 락 매니저
   - 트랜잭션 매니저 : 트랜잭션의 정합성을 유지하면서 실행하는 역할
     * *정합성 : 데이터들의 값이 서로 일치하는 것*
   - 락 매니저 : 데이터에 락을 걸어 다른 사람의 요청을 대기시키는 역할



5. 리커버리 매니저
   - 데이터를 정기적으로 백업하고, 문제가 일어났을 때 복구하는 역할





## DBMS와 버퍼

1. 기억 장치

![슬라이드 1](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfW9Hrua_OZLmxsAwD24IeYpydt1IbGXZ12A&usqp=CAU)

- 버퍼는 성능에 중요한 영향을 미친다.
- 기억 비용(데이터를 저장하는 데 소모되는 비용)에 따라 계층을 분류함.
- 위 그램에서 아래로 내려갈수록 **<u>'같은 비용으로 저장할 수 있는 데이터 용량이 많다'</u>**라는 것을 의미함

- 많은 데이터를 영속적으로 저장하려면 속도를 잃고, 속도를 얻고자 하면 영속성으로 저장하기 힘든 **트레이드 오프가 발생**한다. 즉, 공짜 밥은 없다!!



  (1) HDD

- 용량, 비용, 성능 관점에서 대부분이 데이터를 저장하는 저장소



  (2) 메모리

- 기억 비용 비쌈
- 규모 있는 DB의 데이터를 모두 메모리에 올리는 것은 불가능



  (3) 버퍼를 활용한 속도 향상

- 성능 향상을 목적으로 데이터를 저장하는 메모리. 캐시(cache)라고도 부름.

- 자주 접근하는 데이터를 메모리 위에 올려두면 바로 읽어 빠르게 검색할 수 있음
- *버퍼 매니저 : 버퍼에 데이터를 어떻게 어느 정도의 기간 동안 올릴지 관리하는 역할*



2. 버퍼 종류

  (1) 데이터 캐시

- 디스크에 있는 데이터의 일부를 메모리에 유지하기 위해 사용하는 메모리 영역.
- 데이터가 여기 있다면 응답이 굉장히 빠름 <-> 없다면 응답 속도가 느려짐
- *'디스크를 건드리는 자는 불행해진다'...*



  (2) 로그 버퍼

- 메모리에 갱신 정보를 받으면 사용자에게는 '끝났다'라고 통지하고, 내부적으로 관련된 처리를 계속 수행한다.
- 갱신 시점에 차이가 있음(비동기 처리) - 성능을 높이기 위함임



3. 메모리 관련 트레이드 오프

  **휘발성**

- DBMS 껐다 켜면 버퍼 위 모든 데이터가 사라짐.



  **문제점**

- 장애가 발생하면 데이터가 사라져 부정합을 발생시킴.
- 로그 버퍼 위의 데이터가 로그 파일에 반영 되기 전에 사라진다면? -> 복구 불가능
- -> 커밋 시점에 반드시 갱신 정보를 로그 파일에 씀으로써 정합성을 유지한다.
- *커밋 : 갱신 처리를 '확정'하는 것*

  

- 하지만, 커밋 때 디스크에 동기 접근이 일어나 지연이 발생할 가능성이 있어 트레이드 오프가 일어날 가능성이 있음.

| 이름        | 데이터 정합성 | 성능 |
| ----------- | ------------- | ---- |
| 동기 처리   | O             | X    |
| 비동기 처리 | X             | O    |

​	

4. 시스템 특성 관련 트레이드 오프

- PostgreSQL 초깃값 : 데이터 캐시(128MB) > 로그 버퍼(64KB)
- 데이터 캐시 : **<u>검색을 담당</u>**하는데 대상 레코드가 매우 많기 때문에 용량이 크다.
- 로그 버퍼 : **<u>갱신을 담당</u>**하는데 대상 레코드는 검색에 비해 매우 적다.



5. 워킹 메모리

* 워킹 메모리 : 정렬이나 해시 처리에 사용되는 영역
  * 정렬 : ORDER BY, 집합 연산 등
  * 해시 : 테이블 결합

- 필요할 때 사용되고, 종료되면 해제되는 임시 영역



**만약 저장소가 부족하다면?**

- 메모리에서는 빠르게 작동하다가 부족해지는 순간 갑자기 느려진다.
- 해당 영역은 여러 SQL 구문들이 공유해서 사용해 메모리가 넘칠 수 있다.
- 이러한 현상은 DBMS가 메모리가 부족하더라도 무언가를 처리하려고 계속 노력하는 미들웨어이기 때문이다.





## DBMS와 실행 계획

- 사용자나 개발자는 SQL 레벨까지만 사용하고 나머지는 DBMS에게 맡긴다. -> 생산성 향상

- 사용자는 대상을 기술하는 역할



1. 데이터 접근 방법

![SQL 처리과정 - [종료]구루비 DB 스터디 - 개발자, DBA가 함께 만들어가는 구루비 지식창고!](https://lh3.googleusercontent.com/proxy/PiLvKzz92MpUCw0H0VxytSehUwT6Ky015K6RE95BM4H6fPinnP1ymlqkzn4wp2TobCVIyO7kLHG6WgUkq_hGmIHZoDPnRCqwIpIgs7y0zYZ9-s0)



**파서**

- SQL구문이 올바른지 분석하는 서류 심사 역할을 담당
- SQL 구문을 후속 처리를 위해 정형적인 형식으로 변환



**옵티마이저(최적화)**

- DBMS 두뇌의 핵심
- 선택 가능한 많은 실행 계획을 작성
- 비용 연산
- 가장 낮은 비용을 가진 실행 계획을 선택



**카탈로그 매니저**

- 옵티마이저에 정보 제공
- DBMS의 내부 정보를 모아놓은 테이블
- 테이블 또는 인텍스의 통계 정보가 저장되어 있음



**플랜 평가**

- 최적의 실행결과는 선택하는 역할





## 실행 계획이 SQL 구문의 성능을 결정

- SQL 구문이 너무 복잡하면 옵티마이저가 최적의 방법을 선택하지 못할 수 있다.

- SQL 구문 지연 발생 시 제일 먼저 실행 계획을 보아야 한다.



1. 실행 계획 확인 방법

| 이름       | 명령어                                   |
| ---------- | ---------------------------------------- |
| Oracle     | set autotrace traceonly                  |
| MSSQL      | SET SHOWPLAN_TEXT ON                     |
| DB2        | EXPLAIN ALL WITH SNAPSHOT FOR (SQL 구문) |
| PostgreSQL | EXPLAIN (SQL  구문)                      |
| MySQL      | EXPLAIN EXTENDED (SQL  구문)             |



**테이블 풀 스탠의 실행 계획**

각 DBMS별 출력이 약간 다르지만 다음 3가지는 공통적으로 나타난다.

- 조작 대상 객체
  - 테이블명이 출력됨
  - 여러개의 테이블을 사용하는 경우 혼동 주의
- 객체에 대한 조작의 종류
  - 가장 중요한 부분
  - 풀 스캔시 Oracle에서는 `TABLE ACCESS FULL` , PostgreSQL에서는 `Seq Scan`
- 조작 대상이 되는 레코드 수
  - Rows라는 항목에 출력
  - SQl 구문 전체의 실행 비용 파악하는데 중요한 지표
  - 통계 정보에서 파악한 숫자이기 때문에 실제 SQL 구문 실행 시점과 테이블 레코드 수가 차이날 수 있다.



**인덱스 스캔의 실행 계획(Where)**

- 조작 대상 레코드 수
  - Rows가 1로 출력됨
- 접근 대상 객체와 조작
  - PostgreSQL : `Index Scan`, Oracle : `INDEX UNIQUE SCAN`
  - 스캔하는 레코드 수보다 선택 레코드 수가 적다면 풀 스캔보다 빠르다. -> 인덱스를 사용하면 `B-tree` (O(logn) 방식으로 탐색하기 때문에 풀스캔보다 훨씬 효율적이다.



## 실행 계획의 중요성

1. 옵티마이저는 우수하지만 완벽하지 않아 수정시 튜닝이 필요할 때가 있다. DBMS의 힌트 구를 사용해 강제로 옵티마이저에게 명령할 수 있다.
2. 옵티마이저가 최적의 방법이 아니라면 사람이 직접 변경해야 하는데, 그 전에 다음을 알아야 한다.
   - SQL 구문들이 어떠한 접근 경로로 데이터를 검색하는지 알아야 한다.
   - 어떤 테이블 설정이 효율적인지 알아야 한다.
   - SQL 구문이 주어졌을 때 어떤 실행 계획이 나올지 예측할 수 있어야 한다.


