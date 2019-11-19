
--테이블 생성
create table jdbc_board(
    board_no number not null,  -- 번호(자동증가)
    board_title varchar2(100) not null, -- 제목
    board_writer varchar2(50) not null, -- 작성자
    board_date date not null,   -- 작성날짜
    board_content clob,     -- 내용
    constraint pk_jdbc_board primary key (board_no)
);

--시퀀스
create sequence board_seq
    start with 1   -- 시작번호
    increment by 1;


INSERT INTO jdbc_board VALUES (board_seq.NEXTVAL, '첫번째 게시글', 'abc', SYSDATE, 'hello, world!');
INSERT INTO jdbc_board VALUES (board_seq.NEXTVAL, '두번째 게시글', 'Admin', SYSDATE, 'hello, world!222');

commit;
rollback;


SELECT COUNT(*) cnt
FROM jdbc_board;

UPDATE jdbc_board SET board_title = '세번째 게시글',
                      board_writer = 'guest001',
                      board_content = '무슨말을써야하냐고기먹고싶다'
                      WHERE board_no = 3;


SELECT *
FROM jdbc_board;


SELECT * FROM jdbc_board WHERE board_no LIKE '%7%';


SELECT *
FROM jdbc_board
WHERE board_no = 2;









