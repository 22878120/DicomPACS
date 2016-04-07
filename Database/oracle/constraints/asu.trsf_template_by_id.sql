ALTER TABLE ASU.TRSF_TEMPLATE
  DROP CONSTRAINT TRSF_TEMPLATE_BY_ID
/

-- 
-- Non Foreign Key Constraints for Table TRSF_TEMPLATE 
-- 
ALTER TABLE ASU.TRSF_TEMPLATE ADD (
  CONSTRAINT TRSF_TEMPLATE_BY_ID
 PRIMARY KEY
 (FK_ID))
/
