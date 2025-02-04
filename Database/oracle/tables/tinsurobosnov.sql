ALTER TABLE ASU.TINSUROBOSNOV
 DROP PRIMARY KEY CASCADE
/

DROP TABLE ASU.TINSUROBOSNOV CASCADE CONSTRAINTS
/

--
-- TINSUROBOSNOV  (Table) 
--
CREATE TABLE ASU.TINSUROBOSNOV
(
  FK_ID                  NUMBER                 NOT NULL,
  FK_INSURDOCID          NUMBER,
  FC_OBOSNOVANIE         VARCHAR2(4000 BYTE),
  FD_OBOSNOVANIE_INSERT  DATE                   DEFAULT TRUNC(SYSDATE),
  FL_ACTIVE              NUMBER(1)              DEFAULT 0
)
TABLESPACE USR
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON COLUMN ASU.TINSUROBOSNOV.FK_INSURDOCID IS 'TINSURDOCS.FK_ID'
/

COMMENT ON COLUMN ASU.TINSUROBOSNOV.FL_ACTIVE IS '1-�������'
/


--
-- PK_TINSUROBOSNOV  (Index) 
--
--  Dependencies: 
--   TINSUROBOSNOV (Table)
--
CREATE UNIQUE INDEX ASU.PK_TINSUROBOSNOV ON ASU.TINSUROBOSNOV
(FK_ID)
NOLOGGING
TABLESPACE USR
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


--
-- TINSUROBOSNOV_INSERT  (Trigger) 
--
--  Dependencies: 
--   TINSUROBOSNOV (Table)
--
CREATE OR REPLACE TRIGGER ASU."TINSUROBOSNOV_INSERT" 
  BEFORE INSERT
  ON ASU.TINSUROBOSNOV   REFERENCING NEW AS NEW OLD AS OLD
  FOR EACH ROW
Begin
  select SEQ_TINSUROBOSNOV.NEXTVAL INTO :NEW.FK_ID FROM DUAL;
End;
/
SHOW ERRORS;


-- 
-- Non Foreign Key Constraints for Table TINSUROBOSNOV 
-- 
ALTER TABLE ASU.TINSUROBOSNOV ADD (
  CONSTRAINT PK_TINSUROBOSNOV
 PRIMARY KEY
 (FK_ID)
    USING INDEX 
    TABLESPACE USR
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ))
/

