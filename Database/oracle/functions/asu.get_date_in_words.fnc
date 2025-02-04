DROP FUNCTION ASU.GET_DATE_IN_WORDS
/

--
-- GET_DATE_IN_WORDS  (Function) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DUAL (Synonym)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--
CREATE OR REPLACE FUNCTION ASU.get_date_in_words(pfd_date date, pfk_rodpad in number := 0) return varchar2 is
  -------------------------------------------------------------------------------------------------------
  -- ����������: ���� �������� � ������������ ��� ����������� ������ (������)                          --
  -- ������� ���������: pfd_date - �������������� ����,                                                --
  --                    pfk_rodpad = 0 - ���� � ������������ ������, = 1 - ���� � ����������� ������   --
  --                                                                                                   --
  -- �������: 22.05.2012                                                                               --
  -- �����: ���������� �.�.                                                                            --
  -------------------------------------------------------------------------------------------------------

  dd varchar2(20);
  mmyyyy varchar2(20);
  res varchar2(100);

begin
  if (pfd_date is null) then
    res := null;
  else
    -- ����
    -- ������������ �����
    if (pfk_rodpad = 0) then
      select decode(extract(day from pfd_date),
                       1, '������',
                       2, '������',
                       3, '������',
                       4, '���������',
                       5, '�����',
                       6, '������',
                       7, '�������',
                       8, '�������',
                       9, '�������',
                      10, '�������',
                      11, '������������',
                      12, '�����������',
                      13, '�����������',
                      14, '�������������',
                      15, '�����������',
                      16, '������������',
                      17, '�����������',
                      18, '�������������',
                      19, '�������������',
                      20, '���������',
                      21, '�������� ������',
                      22, '�������� ������',
                      23, '�������� ������',
                      24, '�������� ���������',
                      25, '�������� �����',
                      26, '�������� ������',
                      27, '�������� �������',
                      28, '�������� �������',
                      29, '�������� �������',
                      30, '���������',
                      31, '�������� ������',
                      null
                   )
        into dd
        from dual;

    -- ����������� �����
    elsif (pfk_rodpad = 1) then
      select decode(extract(day from pfd_date),
                       1, '�������',
                       2, '�������',
                       3, '��������',
                       4, '����������',
                       5, '������',
                       6, '�������',
                       7, '��������',
                       8, '��������',
                       9, '��������',
                      10, '��������',
                      11, '�������������',
                      12, '������������',
                      13, '������������',
                      14, '��������������',
                      15, '������������',
                      16, '�������������',
                      17, '������������',
                      18, '��������������',
                      19, '��������������',
                      20, '����������',
                      21, '�������� �������',
                      22, '�������� �������',
                      23, '�������� ��������',
                      24, '�������� ����������',
                      25, '�������� ������',
                      26, '�������� �������',
                      27, '�������� ��������',
                      28, '�������� ��������',
                      29, '�������� ��������',
                      30, '����������',
                      31, '�������� �������',
                      null
                   )
        into dd
        from dual;
    end if;

    -- ����� � ���
/*
    select rtrim(replace(translate(to_char(pfd_date, 'month', 'nls_date_language = RUSSIAN'), '��', '��'), '�', '��') ) ||
           to_char(pfd_date,' YYYY') || ' ����'
      into mmyyyy
      from dual;
*/
    select rtrim(decode(to_char(pfd_date, 'mm'),
                        '09',
                        translate(to_char(pfd_date, 'month', 'nls_date_language = RUSSIAN'), '��', '��'),
                        '10',
                        translate(to_char(pfd_date, 'month', 'nls_date_language = RUSSIAN'), '��', '��'),
                        replace(translate(to_char(pfd_date, 'month', 'nls_date_language = RUSSIAN'), '��', '��'), '�', '��')
                 )
           ) || to_char(sysdate,' YYYY') || ' ����'
      into mmyyyy
      from dual;

    -- ���� + ����� � ���
    res := trim(dd || ' ' || mmyyyy);

  end if;

  return res;
end;
/

SHOW ERRORS;


