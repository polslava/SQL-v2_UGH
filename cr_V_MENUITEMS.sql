
  CREATE OR REPLACE FORCE VIEW "UGH"."V_MENUITEMS" ("MENUITEMID", "PARENTITEMID", "GROUPID", "POSITION", "TEXT", "XMLNAME", "REFID", "������������ ����", "���������������� ������") AS 
  select m."MENUITEMID",m."PARENTITEMID",m."GROUPID",m."POSITION",m."TEXT",m."XMLNAME",m."REFID" 
    , m1.text as "������������ ����"
    , g.name as "���������������� ������"
    from LOGIN.menuitems m
    left join LOGIN.menuitems m1 on m1.menuitemid = m.parentitemid
    left join LOGIN.groups g on g.groupid = m.groupid
    order by m.xmlname;
