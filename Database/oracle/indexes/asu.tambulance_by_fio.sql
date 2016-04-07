DROP INDEX ASU.TAMBULANCE_BY_FIO
/

--
-- TAMBULANCE_BY_FIO  (Index) 
--
CREATE INDEX ASU.TAMBULANCE_BY_FIO ON ASU.TAMBULANCE
(FC_FAM, FC_OTCH, FC_IM, FD_ROJD)
NOLOGGING
TABLESPACE INDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          17072K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/

