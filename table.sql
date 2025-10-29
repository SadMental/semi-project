------------------------------------------------------------
--  1. 회원 등급 테이블
------------------------------------------------------------
CREATE TABLE MEMBER_LEVEL_TABLE (
    LEVEL_NO      NUMBER PRIMARY KEY,
    LEVEL_NAME    VARCHAR2(30) UNIQUE NOT NULL,
    MIN_POINT NUMBER NOT NULL,
    MAX_POINT NUMBER NOT NULL,
    DESCRIPTION VARCHAR2(255)
);

------------------------------------------------------------
--  2. 회원 테이블
------------------------------------------------------------
CREATE TABLE MEMBER (
    MEMBER_ID          VARCHAR2(1000) PRIMARY KEY,
    MEMBER_PW          VARCHAR2(1000) NOT NULL,
    MEMBER_NICKNAME    VARCHAR2(1000) UNIQUE NOT NULL,
    MEMBER_EMAIL       VARCHAR2(1000) UNIQUE,
    MEMBER_DESCRIPTION VARCHAR2(2000),
    MEMBER_POINT       NUMBER DEFAULT 0 NOT NULL,
    MEMBER_LEVEL       NUMBER DEFAULT 1 NOT NULL
        REFERENCES MEMBER_LEVEL_TABLE(LEVEL_NO),
    MEMBER_AUTH        CHAR(1) DEFAULT 'f' NOT NULL,
    MEMBER_JOIN         TIMESTAMP DEFAULT SYSTIMESTAMP,
    MEMBER_LOGIN       TIMESTAMP DEFAULT SYSTIMESTAMP,
    MEMBER_CHANGE   TIMESTAMP DEFAULT SYSTIMESTAMP,
    CHECK (
        REGEXP_LIKE(MEMBER_PW, '[A-Z]+') AND
        REGEXP_LIKE(MEMBER_PW, '[a-z]+') AND
        REGEXP_LIKE(MEMBER_PW, '[0-9]+') AND
        REGEXP_LIKE(MEMBER_PW, '[!@#$]+')
    ),
    CHECK (
        REGEXP_LIKE(MEMBER_ID, '^[A-Za-z][A-Za-z0-9]{1,20}$')
    )
);

------------------------------------------------------------
--  3. 카테고리 테이블
------------------------------------------------------------
CREATE TABLE CATEGORY (
    CATEGORY_NO    NUMBER PRIMARY KEY,
    CATEGORY_NAME  VARCHAR2(1000) NOT NULL UNIQUE
);
------------------------------------------------------------
--  4. 타입 헤더 테이블 (게시판 유형)
------------------------------------------------------------
CREATE TABLE TYPE_HEADER (
    HEADER_NO    NUMBER PRIMARY KEY,
    HEADER_NAME  VARCHAR2(30) NOT NULL UNIQUE
);

------------------------------------------------------------
--  5. 동물 헤더 테이블
------------------------------------------------------------
CREATE TABLE ANIMAL_HEADER (
    HEADER_NO    NUMBER PRIMARY KEY,
    HEADER_NAME  VARCHAR2(30) NOT NULL UNIQUE
);

------------------------------------------------------------
--  7. 미디어/파일 관련 테이블
------------------------------------------------------------
CREATE TABLE MEDIA (
    MEDIA_NO   NUMBER PRIMARY KEY,
    MEDIA_NAME VARCHAR2(1000) NOT NULL,
    MEDIA_TYPE VARCHAR2(50) NOT NULL,
    MEDIA_SIZE NUMBER NOT NULL,
    MEDIA_WTIME TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE ATTACHMENT (
    ATTACHMENT_NO   NUMBER PRIMARY KEY,
    ATTACHMENT_NAME VARCHAR2(255) NOT NULL,
    ATTACHMENT_TYPE VARCHAR2(100) NOT NULL,
    ATTACHMENT_SIZE NUMBER NOT NULL,
    ATTACHMENT_TIME TIMESTAMP DEFAULT SYSTIMESTAMP
);

------------------------------------------------------------
--  8. 뱃지 테이블
------------------------------------------------------------
CREATE TABLE BADGE (
    BADGE_NO   NUMBER PRIMARY KEY,
    BADGE_NAME VARCHAR2(1000) NOT NULL,
    BADGE_TYPE VARCHAR2(1000) NOT NULL
);

------------------------------------------------------------
--  9. 인증 테이블
------------------------------------------------------------
CREATE TABLE CERT (
    CERT_EMAIL VARCHAR2(1000) PRIMARY KEY,
    CERT_CODE  VARCHAR2(1000) NOT NULL,
    CERT_TIME  DATE DEFAULT SYSDATE NOT NULL
);

------------------------------------------------------------
--  10. 반려동물 정보
------------------------------------------------------------
CREATE TABLE ANIMAL (
    ANIMAL_NO       NUMBER PRIMARY KEY,
    ANIMAL_NAME     VARCHAR2(1000) NOT NULL,
    ANIMAL_TYPE     VARCHAR2(1000) NOT NULL,
    ANIMAL_BIRTH    DATE,
    ANIMAL_OWNER    VARCHAR2(1000)
        REFERENCES MEMBER(MEMBER_ID)
);

------------------------------------------------------------
--  11. 게시판 테이블
------------------------------------------------------------
CREATE TABLE BOARD (
    BOARD_NO             NUMBER PRIMARY KEY,
    BOARD_WRITER         VARCHAR2(1000)
        REFERENCES MEMBER(MEMBER_ID),
    BOARD_TITLE          VARCHAR2(1000) NOT NULL,
    BOARD_CONTENT        CLOB NOT NULL,
    BOARD_WTIME          DATE DEFAULT SYSDATE NOT NULL,
    BOARD_ETIME          DATE DEFAULT SYSDATE NOT NULL,
    BOARD_VIEW           NUMBER DEFAULT 0 NOT NULL,
    BOARD_LIKE           NUMBER DEFAULT 0 NOT NULL,
    BOARD_REPLY          NUMBER DEFAULT 0 NOT NULL,
    BOARD_CATEGORY_NO    NUMBER
        REFERENCES CATEGORY(CATEGORY_NO),
    BOARD_TYPE_HEADER    NUMBER
        REFERENCES TYPE_HEADER(HEADER_NO),
    BOARD_ANIMAL_HEADER  NUMBER
        REFERENCES ANIMAL_HEADER(HEADER_NO)
);

------------------------------------------------------------
--  12. 게시판 관련 부가 테이블
------------------------------------------------------------
CREATE TABLE BOARD_IMAGE (
    BOARD_IMAGE_NO  NUMBER PRIMARY KEY,
    BOARD_IMAGE_SRC VARCHAR2(2000) NOT NULL,
    BOARD_NO        NUMBER REFERENCES BOARD(BOARD_NO)
);

CREATE TABLE BOARD_VIDEO (
    BOARD_VIDEO_NO  NUMBER PRIMARY KEY,
    BOARD_VIDEO_SRC VARCHAR2(2000) NOT NULL,
    BOARD_NO        NUMBER REFERENCES BOARD(BOARD_NO)
);

CREATE TABLE BOARD_LIKE (
    BOARD_LIKE_NO  NUMBER PRIMARY KEY,
    MEMBER_ID      VARCHAR2(1000)
        REFERENCES MEMBER(MEMBER_ID),
    BOARD_NO       NUMBER
        REFERENCES BOARD(BOARD_NO)
);

------------------------------------------------------------
--  13. 프로필 이미지 테이블
------------------------------------------------------------
CREATE TABLE ANIMAL_PROFILE (
    PROFILE_NO     NUMBER PRIMARY KEY,
    ANIMAL_NO      NUMBER REFERENCES ANIMAL(ANIMAL_NO),
    ATTACHMENT_NO  NUMBER REFERENCES ATTACHMENT(ATTACHMENT_NO)
);

CREATE TABLE MEMBER_PROFILE (
    PROFILE_NO     NUMBER PRIMARY KEY,
    MEMBER_ID      VARCHAR2(1000) REFERENCES MEMBER(MEMBER_ID),
    ATTACHMENT_NO  NUMBER REFERENCES ATTACHMENT(ATTACHMENT_NO)
);

------------------------------------------------------------
--  14. 메일 (쪽지) 테이블
------------------------------------------------------------
CREATE TABLE MAIL (
    MAIL_NO      NUMBER PRIMARY KEY,
    MAIL_OWNER   VARCHAR2(1000) REFERENCES MEMBER(MEMBER_ID),
    MAIL_SENDER  VARCHAR2(1000) NOT NULL,
    MAIL_TARGET  VARCHAR2(1000) NOT NULL,
    MAIL_TITLE   VARCHAR2(1000) NOT NULL,
    MAIL_CONTENT VARCHAR2(4000) NOT NULL,
    MAIL_TIME    DATE DEFAULT SYSDATE NOT NULL,
    MAIL_READ    CHAR(1) DEFAULT 'f' NOT NULL
);

------------------------------------------------------------
--  15. 뷰
------------------------------------------------------------
CREATE OR REPLACE VIEW BOARD_LIST AS
SELECT
    B.BOARD_NO,
    B.BOARD_TITLE,
    B.BOARD_WRITER,
    B.BOARD_WTIME,
    B.BOARD_ETIME,
    B.BOARD_LIKE,
    B.BOARD_VIEW,
    B.BOARD_REPLY,
    T.HEADER_NAME  AS TYPE_HEADER_NAME,
    A.HEADER_NAME  AS ANIMAL_HEADER_NAME
FROM BOARD B
LEFT JOIN TYPE_HEADER   T ON B.BOARD_TYPE_HEADER   = T.HEADER_NO
LEFT JOIN ANIMAL_HEADER A ON B.BOARD_ANIMAL_HEADER = A.HEADER_NO;
