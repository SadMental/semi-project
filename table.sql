-- 회원 테이블
create table member(
    -- 회원의 ID
	member_id varchar2(1000) primary key,
    -- 회원의 비밀번호
	member_pw varchar2(1000) not null,
    -- 회원의 닉네임
	member_nickname varchar2(1000) not null unique,
    -- 회원의 이메일
	member_email varchar2(1000) unique,
    -- 회원의 소개글
	member_description varchar2(2000),
    -- 회원의 포인트
	member_point number default 0 not null,
    -- 회원의 관리등급
	member_level number default 1 not null,
    -- 회원의 이메일 인증 여부
	member_auth char(1) default 'f' not null,
    -- 회원이 회원가입한 시간
	member_join timestamp default systimestamp,
    -- 회원의 최근 로그인 시간(최초 회원가입시 로그인했던것으로 취급)
	member_login timestamp default systimestamp,
    -- 회원의 마지막 비밀번호 변경 시간(최초 회원가입시 비밀변호 변경했던것으로 취급)
	member_change timestamp default systimestamp
);

-- 동물 테이블
create table animal(
    -- 동물 번호
	animal_no number primary key,
    -- 동물 이름
	animal_name varchar2(1000) not null,
    -- 동물 소개글
    animal_cotent varchar2(2000),
    -- 동물의 분양 가능여부
	animal_permission char(1) default 'f' not null,
    -- 동물의 소유주 id
    animal_master references member(member_id) on delete cascade
);
create sequence animal_seq;

-- 우편함 테이블
create table mail(
    -- 우편 번호
    mail_no number primary key,
    -- 우편을 보낸 회원
	mail_sender references member(member_id) on delete set null,
    -- 우편을 받을 회원
	mail_target references member(member_id) on delete set null,
    -- 우편의 내용
	mail_content varchar2(2000) not null,
    -- 우편 작성 시간
	mail_wtime timestamp default systimestamp not null
);

-- alter table mail add (mail_no number primary key);
create sequence mail_seq;

-- 카테고리 테이블
create table category(
    -- 카테고리 번호
	category_no number primary key,
    -- 카테고리 이름
	category_name varchar2(1000) not null unique
);

create sequence category_seq;

-- 게시글 테이블
create table board(
    -- 게시글의 카테고리 번호
	board_category_no references category(category_no) on delete cascade,
    -- 게시글의 번호
	board_no number primary key,
    -- 게시글의 제목
    board_title varchar2(1000) not null,
    -- 게시글의 내용
	board_content varchar2(4000) not null,
    -- 게시글의 작성자
	board_writer references member(member_id) on delete set null,
    -- 게시글의 작성시간
	board_wtime timestamp default systimestamp,
    -- 게시글의 수정시간
	board_etime timestamp,
    -- 게시글의 추천수
	board_like number default 0 not null,
    -- 게시글의 조회수
	board_view number default 0 not null,
    -- 게시글의 머리글 번호
	board_header references header(header_no) on delete set null
);

create sequence board_seq;

-- 머리글 테이블
create table header(
    -- 머리글의 번호
	header_no number primary key,
    -- 머리글의 이름
	header_name varchar2(30)
);

create sequence header_seq;

create table media(
    -- 미디어(이미지, 영상)의 번호
	media_no number primary key,
    -- 미디어의 종류(확장자)
	media_type char(4) not null,
    -- 미디어의 본래 이름
	media_name varchar2(1000) not null,
    -- 미디어의 크기
    media_size number not null,
    -- 미디어가 저장된 시간
	media_wtime timestamp default systimestamp,
);

create sequence media_seq;

-- 댓글 테이블
create table reply(
    -- 댓글의 카테고리 번호
	reply_category_no references category(category_no) on delete cascade,
    -- 댓글이 쓰여진 게시판 번호
	reply_target references board(board_no) on delete cascade,
    -- 댓글의 번호
    reply_no number primary key,
    -- 댓글의 내용
	reply_content varchar2(2000),
    -- 댓글의 작성자
	reply_writer references member(member_id) on delete set null,
    -- 댓글이 작성된 시간
	reply_wtime timestamp default systimestamp,
    -- 댓글이 수정된 시간
	reply_etime timestamp
);

create sequence reply_seq;

-- 어드민의 활동 로그 기록용 테이블
create table log(
    -- 로그 번호
    log_no number primary key,
    -- 어드민의 ID
    admin_id references member(member_id) on delete set null,
    -- 멤버의 ID
    target_id references member(member_id) on delete set null,
    -- 로그의 종류(ex. update, delete)
    log_type varchar2(100) not null,
    -- 로그가 기록될 제목(ex. admin_id의 target_id에 대한 log_type)
    log_title varchar2(100) not null,
    -- 로그의 상세내용(ex. admin_id가 target_id의 category_no의 board_no에 대해서 log_type을 수행했다.)
    log_detail varchar2(2000) not null,
    -- 로그의 기록 시간
    log_wtime timestamp default systimestamp,
    -- 활동한 어드민의 IP
    admin_ip varchar2(50) not null
)

-- 이메일 인증 테이블
create table cert (
	-- 인증 할 이메일
	cert_email varchar2(60) primary key,
	-- 인증 번호
	cert_number char(5) not null,
	-- 인증 시간
	cert_time timestamp default systimestamp not null,
	-- 인증번호 조건
	check(regexp_like(cert_number, '^[0-9]{5}$'))
);
