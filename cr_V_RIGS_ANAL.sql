
  CREATE OR REPLACE FORCE VIEW "UGH"."V_RIGS_ANAL" ("RIGNAME", "�������", "��������") AS 
  select rg.rigname, "�������", "��������" from UGH.VM_RIGS_ANAL@rigs ra
inner join rigs.rigs@rigs rg on rg.rigid=ra.rigid
;
