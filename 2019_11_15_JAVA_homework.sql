
--���̺� ����
create table jdbc_board(
    board_no number not null,  -- ��ȣ(�ڵ�����)
    board_title varchar2(100) not null, -- ����
    board_writer varchar2(50) not null, -- �ۼ���
    board_date date not null,   -- �ۼ���¥
    board_content clob,     -- ����
    constraint pk_jdbc_board primary key (board_no)
);

--������
create sequence board_seq
    start with 1   -- ���۹�ȣ
    increment by 1;


INSERT INTO jdbc_board VALUES (board_seq.NEXTVAL, 'ù��° �Խñ�', 'abc', SYSDATE, 'hello, world!');
INSERT INTO jdbc_board VALUES (board_seq.NEXTVAL, '�ι�° �Խñ�', 'Admin', SYSDATE, 'hello, world!222');

commit;
rollback;


SELECT COUNT(*) cnt
FROM jdbc_board;

UPDATE jdbc_board SET board_title = '����° �Խñ�',
                      board_writer = 'guest001',
                      board_content = '������������ϳİ��԰�ʹ�'
                      WHERE board_no = 3;


SELECT *
FROM jdbc_board;


SELECT * FROM jdbc_board WHERE board_no LIKE '%7%';


SELECT *
FROM jdbc_board
WHERE board_no = 2;









