
  CREATE OR REPLACE FORCE VIEW "UGH"."V_RIGS_IN_SHIFT_TASK" ("RIGID", "RN") AS 
  select rigid, rownum as rn from (
select rigid from RIGS.SHIFTTASKS_V2@rigs t
where task_date=ugh.Getcurshiftdate(0,sysdate,12) and shift=ugh.getCurShiftNum(0,sysdate,12) and
waylist is not null and tabel_num<>0
MINUS
select t_2.rigid from rigs.repairsheets@rigs t_2 where t_2.timebegin<=UGH.Getcurshiftfrom and t_2.timeend>=UGH.Getcurshiftto
MINUS
select TO_NUMBER(t_3.vehid) as rigid from rigs.manualstoppages@rigs t_3 where t_3.timestop<=UGH.Getcurshiftfrom and t_3.timego>=UGH.Getcurshiftto and
       typeid in (select ustp.code from rigs.userstoppagetypes@rigs ustp where ustp.categoryid=6)
)
;
