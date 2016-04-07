DROP INDEX ASU.TNAZOPER_DIAG_BY_NAZDIAGID
/

--
-- TNAZOPER_DIAG_BY_NAZDIAGID  (Index) 
--
CREATE INDEX ASU.TNAZOPER_DIAG_BY_NAZDIAGID ON ASU.TNAZOPER_DIAG
(FK_NAZOPERID, FK_DIAGID)
NOLOGGING
TABLESPACE INDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/

