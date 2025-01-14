DROP TABLE ASU.VNAZ_PAT_PATOLOGY CASCADE CONSTRAINTS
/

--
-- VNAZ_PAT_PATOLOGY  (Table) 
--
--  Dependencies: 
--   VNAZ (Table)
--
CREATE TABLE ASU.VNAZ_PAT_PATOLOGY
(
  FK_NAZID  NUMBER                              NOT NULL
)
TABLESPACE USR
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
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

COMMENT ON TABLE ASU.VNAZ_PAT_PATOLOGY IS '������� � ��������� � ���������'
/

COMMENT ON COLUMN ASU.VNAZ_PAT_PATOLOGY.FK_NAZID IS 'id �������'
/


--
-- VNAZ_PAT_PATOLOGY_NAZID  (Index) 
--
--  Dependencies: 
--   VNAZ_PAT_PATOLOGY (Table)
--
CREATE UNIQUE INDEX ASU.VNAZ_PAT_PATOLOGY_NAZID ON ASU.VNAZ_PAT_PATOLOGY
(FK_NAZID)
NOLOGGING
TABLESPACE INDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
/


-- 
-- Foreign Key Constraints for Table VNAZ_PAT_PATOLOGY 
-- 
ALTER TABLE ASU.VNAZ_PAT_PATOLOGY ADD (
  CONSTRAINT PK_VNAZ_PAT_PATOLOGY 
 FOREIGN KEY (FK_NAZID) 
 REFERENCES ASU.VNAZ (FK_ID)
    ON DELETE CASCADE)
/

