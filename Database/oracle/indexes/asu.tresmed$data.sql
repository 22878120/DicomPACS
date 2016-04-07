DROP INDEX ASU.TRESMED$DATA
/

--
-- TRESMED$DATA  (Index) 
--
CREATE INDEX ASU.TRESMED$DATA ON ASU.TRESMED
(FD_DATA)
NOLOGGING
TABLESPACE INDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          768K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/

