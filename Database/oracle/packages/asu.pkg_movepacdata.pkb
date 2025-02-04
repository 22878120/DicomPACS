DROP PACKAGE BODY ASU.PKG_MOVEPACDATA
/

--
-- PKG_MOVEPACDATA  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY ASU."PKG_MOVEPACDATA" IS
  -- by Marriage
  -- Edited by Spasskiy S.N. 15032010 ������� ���������� �� mview
  -- Edited by Spasskiy S.N. 11052010 ������� ORA_USERS, TPEOPLES_COMPANY � COPY_PEOPELE

  PROCEDURE COPY_PAC(FROM_PAC IN NUMBER, TO_PAC IN NUMBER) IS
  BEGIN
    BEGIN
      FOR C IN (SELECT A.TABLE_NAME, A.COLUMN_NAME
                  FROM USER_COL_COMMENTS A,
                       USER_TAB_COMMENTS B,
                       USER_TABLES       C
                 WHERE COLUMN_NAME IN ('FK_AMBID', 'FK_PACID')
                   AND C.TABLE_NAME = A.TABLE_NAME
                   AND A.TABLE_NAME = B.TABLE_NAME
                   AND A.TABLE_NAME NOT IN
                       (SELECT M.CONTAINER_NAME FROM DBA_MVIEWS M)
                   AND A.TABLE_NAME NOT IN
                       ('TADRESS',
                        'TPUTSPLANS',
                        'TDOC',
                        'TPERESEL',
                        'TSROKY',
                        'TPAC_INSURANCE',
                        'TVRACH',
                        'TAMBVRACH',
                        'TIBDEFEKT',
                        'TIBPAC_RAZ',
                        'TIBXMLTEXT',
                        'TCONTACTS',
                        'TIB',
                        'TANAMNEZ',
                        'TSMIDCHECKFORKARTA',
                        'TNEXTYAVKA',
                        'TLASTNAZS',
                        'TAMBULANCE_INFO')
                   AND C.TEMPORARY = 'N') LOOP
        DBMS_OUTPUT.PUT_LINE(C.TABLE_NAME);
        EXECUTE IMMEDIATE 'UPDATE ' || C.TABLE_NAME || ' SET ' ||
                          C.COLUMN_NAME || ' = :FK_NEWID  WHERE ' ||
                          C.COLUMN_NAME || ' = :FK_OLD '
          USING TO_PAC, FROM_PAC;
      END LOOP;
      DELETE FROM TKARTA WHERE FK_ID = FROM_PAC;
      DELETE FROM TAMBULANCE WHERE FK_ID = FROM_PAC;
    END;
  END;
  PROCEDURE COPY_PEOPELE(FROM_PEOPLE IN NUMBER, TO_PEOPLE IN NUMBER) IS
    N1 NUMBER;
    N2 NUMBER;
    N3 NUMBER;
    N4 NUMBER;
  
    PFC_RABOTA    VARCHAR2(4000);
    PFC_FAM       VARCHAR2(4000);
    PFC_IM        VARCHAR2(4000);
    PFC_OTCH      VARCHAR2(4000);
    PFD_ROJD      DATE;
    PFC_FAX       VARCHAR2(4000);
    PFC_EMAIL     VARCHAR2(4000);
    PFC_HTTP      VARCHAR2(4000);
    PFC_DOCSER    VARCHAR2(4000);
    PFC_DOCNUM    VARCHAR2(4000);
    PFC_DOCVIDAN  VARCHAR2(4000);
    PFD_DOCDATE   DATE;
    PFK_COMPANY   NUMBER;
    PFK_OTDEL     NUMBER;
    PFK_DOLGNOST  NUMBER;
    PFC_ROJDPLACE VARCHAR2(4000);
  
  BEGIN
    UPDATE TBIRTH_CERTIFICATION
       SET FK_PEPLID = TO_PEOPLE
     WHERE FK_PEPLID = FROM_PEOPLE;
    UPDATE TLINK_PEOPLES
       SET FK_PEPLID = TO_PEOPLE
     WHERE FK_PEPLID = FROM_PEOPLE;
    UPDATE LOGIN.TSOTR
       SET FK_PEPLID = TO_PEOPLE
     WHERE FK_PEPLID = FROM_PEOPLE;
    UPDATE LOGIN.TPASS
       SET FK_PEPLID = TO_PEOPLE
     WHERE FK_PEPLID = FROM_PEOPLE;
    BEGIN
      UPDATE LOGIN.ORA_USERS
         SET FK_PEPLID = TO_PEOPLE
       WHERE FK_PEPLID = FROM_PEOPLE;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    UPDATE ASU.TDOC SET FK_PACID = TO_PEOPLE WHERE FK_PACID = FROM_PEOPLE;
    UPDATE ASU.TINSURDOCS
       SET FK_PEPLID = TO_PEOPLE
     WHERE FK_PEPLID = FROM_PEOPLE;
    /*      UPDATE ASU.TADRESS
             SET FK_PACID = TO_PEOPLE
           WHERE FK_PACID = FROM_PEOPLE
    */
    FOR C IN (SELECT FK_ID FROM ASU.TADRESS WHERE FK_PACID = FROM_PEOPLE) LOOP
      BEGIN
        UPDATE ASU.TADRESS SET FK_PACID = TO_PEOPLE WHERE FK_ID = C.FK_ID;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END LOOP;
    UPDATE ASU.TPEOPLES_COMPANY
       SET FK_PEOPLEID = TO_PEOPLE
     WHERE FK_PEOPLEID = FROM_PEOPLE;
  
    /*SELECT FC_RABOTA,
           FC_FAM,
           FC_IM,
           FC_OTCH,
           FD_ROJD,
           FC_FAX,
           FC_E_MAIL,
           FC_HTTP,
           FC_DOCSER,
           FC_DOCNUM,
           FC_DOCVIDAN,
           FD_DOCDATE,
           FK_COMPANYID,
           FK_OTDEL,
           FK_DOLGNOST,
           FC_ROJDPLACE
      into pFC_RABOTA,
           pFC_FAM,
           pFC_IM,
           pFC_OTCH,
           pFD_ROJD,
           pFC_FAX,
           pFC_EMAIL,
           pFC_HTTP,
           pFC_DOCSER,
           pFC_DOCNUM,
           pFC_DOCVIDAN,
           pFD_DOCDATE,
           pFK_COMPANY,
           pFK_OTDEL,
           pFK_DOLGNOST,
           pFC_ROJDPLACE
      from TPEOPLES
     where FK_ID = FROM_PEOPLE;
    
    UPDATE TPeoples
       SET FC_RABOTA    = pFC_RABOTA,
           FC_FAM       = pFC_FAM,
           FC_IM        = pFC_IM,
           FC_OTCH      = pFC_OTCH,
           FD_ROJD      = pFD_ROJD,
           FC_FAX       = pFC_FAX,
           FC_E_MAIL    = pFC_EMAIL,
           FC_HTTP      = pFC_HTTP,
           FC_DOCSER    = pFC_DOCSER,
           FC_DOCNUM    = pFC_DOCNUM,
           FC_DOCVIDAN  = pFC_DOCVIDAN,
           FD_DOCDATE   = pFD_DOCDATE,
           FK_COMPANYID = pFK_COMPANY,
           FK_OTDEL     = pFK_OTDEL,
           FK_DOLGNOST  = pFK_DOLGNOST,
           FC_ROJDPLACE = pFC_ROJDPLACE
     WHERE FK_ID = TO_PEOPLE;*/
  
    UPDATE TKARTA SET FK_PEPLID = TO_PEOPLE WHERE FK_PEPLID = FROM_PEOPLE;
    UPDATE TAMBULANCE
       SET FK_PEPLID = TO_PEOPLE
     WHERE FK_PEPLID = FROM_PEOPLE;
  
    UPDATE ASU.TCONTACTS
       SET FK_PACID = TO_PEOPLE
     WHERE FK_PACID = FROM_PEOPLE;
    SELECT COUNT(1) INTO N1 FROM ASU.TVAC_MAP WHERE FK_PEOPLE = TO_PEOPLE;
    IF N1 = 0 THEN
      UPDATE TVAC_MAP
         SET FK_PEOPLE = TO_PEOPLE
       WHERE FK_PEOPLE = FROM_PEOPLE;
    END IF;
    ------------------
    PKG_VACCIN.MERGEING_PEOPLE(TO_PEOPLE, FROM_PEOPLE, N1, N2, N3, N4);
    --DELETE FROM TPEOPLES WHERE FK_ID = FROM_PEOPLE;
    SAVE_PASS(FROM_PEOPLE, TO_PEOPLE);
    DELETE_PEOPELE(FROM_PEOPLE);
    --DELETE FROM TWORKPLACE WHERE FK_PACID = FROM_PEOPLE;
  END;

  PROCEDURE DELETE_PEOPELE(PFK_PEOPLE IN NUMBER) IS
  BEGIN
    DELETE FROM ASU.TVAC_PEOPLES_TEST A WHERE A.FK_PEOPLE = PFK_PEOPLE;
  
    DELETE FROM ASU.TVAC_MAP A WHERE A.FK_PEOPLE = PFK_PEOPLE;
  
    DELETE FROM ASU.TVAC_CANCEL A WHERE A.FK_PEOPLE = PFK_PEOPLE;
  
    DELETE FROM ASU.TVAC_SICNESS A WHERE A.FK_PEOPLE = PFK_PEOPLE;
  
    DELETE FROM ASU.TVAC_PLAN A WHERE A.FK_PEOPLE = PFK_PEOPLE;
  
    DELETE FROM ASU.TVAC_PRIVATE_PLAN A WHERE A.FK_PEOPLE = PFK_PEOPLE;
  
    DELETE FROM ASU.TVAC_KRATN
     WHERE ASU.TVAC_KRATN.FK_VAC_PEOPLE IN
           (SELECT ASU.TVAC_PEOPLE.FK_ID
              FROM ASU.TVAC_PEOPLE
             WHERE ASU.TVAC_PEOPLE.FK_PEOPLE = PFK_PEOPLE);
    DELETE FROM TWORKPLACE WHERE FK_PACID = PFK_PEOPLE;
  
    DELETE FROM ASU.TPEOPLES WHERE FK_ID = PFK_PEOPLE;
  END;

  PROCEDURE SAVE_PASS(FROM_PEPL IN NUMBER, TO_PEPL IN NUMBER) IS
    TO_PEPL_PASS   NUMBER := NULL;
    FROM_PEPL_PASS NUMBER := NULL;
    CURSOR C(PEPLID NUMBER) IS
      SELECT O.FK_ID FROM LOGIN.ORA_USERS O WHERE O.FK_PEPLID = PEPLID;
  BEGIN
    OPEN C(TO_PEPL);
    FETCH C
      INTO TO_PEPL_PASS;
    IF C%NOTFOUND THEN
      TO_PEPL_PASS := NULL;
      RETURN;
    END IF;
    CLOSE C;
  
    IF TO_PEPL_PASS IS NULL THEN
      OPEN C(FROM_PEPL);
      FETCH C
        INTO FROM_PEPL_PASS;
      IF C%NOTFOUND THEN
        FROM_PEPL_PASS := NULL;
        RETURN;
      END IF;
      CLOSE C;
    END IF;
  
    IF FROM_PEPL_PASS IS NOT NULL THEN
      UPDATE LOGIN.ORA_USERS O
         SET O.FK_PEPLID = TO_PEPL
       WHERE O.FK_ID = FROM_PEPL_PASS;
    END IF;
  
  END;

END; -- Package Body PKG_SMINI
/

SHOW ERRORS;


