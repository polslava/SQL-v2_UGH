
  CREATE OR REPLACE FORCE VIEW "UGH"."V_SHIFTREPORTSADV_MONTH_WORKS" ("VEHID", "TASKDATE", "SHIFT", "SHOVID", "UNLOADID", "LOADTYPE", "WORKTYPE", "AVLENGTH", "ROUTELENGTH", "LENGTHMANUAL", "WEIGHTSENSOR", "GPSSENSOR", "TRIPNUMBERAUTO", "TRIPNUMBERMANUAL", "AVWEIGHT", "MAXWEIGHT", "MINWEIGHT", "WEIGHTRATE", "VOLUMERATE", "SPECIFICFUELRATE", "ISEDITED", "ISLASTROUTE", "MASH_SMEN", "AREA", "WORK_TIME_MANUAL", "WORK_TIME_AUTO", "INSERTTIME", "UPDATETIME", "UPDATESNUM", "AVWEIGHTONINSERT", "CUSTOMERNAME", "DANGERLEVEL", "KVDR_CODE", "LOADHEIGHT", "UNLOADHEIGHT", "STOPTIME", "REPAIRTIME", "REPAIR_IS_TO", "UNLOADIDFORLOAD", "ALLLENGTH", "REPORTSHIFT", "REPORTDATE", "AVHEIGHT", "AVGXLOAD", "AVGYLOAD", "WEIGHT", "WORKTYPE1") AS 
  SELECT "VEHID","TASKDATE","SHIFT","SHOVID","UNLOADID","LOADTYPE","WORKTYPE","AVLENGTH","ROUTELENGTH","LENGTHMANUAL","WEIGHTSENSOR","GPSSENSOR","TRIPNUMBERAUTO","TRIPNUMBERMANUAL","AVWEIGHT","MAXWEIGHT","MINWEIGHT","WEIGHTRATE","VOLUMERATE","SPECIFICFUELRATE","ISEDITED","ISLASTROUTE","MASH_SMEN","AREA","WORK_TIME_MANUAL","WORK_TIME_AUTO","INSERTTIME","UPDATETIME","UPDATESNUM","AVWEIGHTONINSERT","CUSTOMERNAME","DANGERLEVEL","KVDR_CODE","LOADHEIGHT","UNLOADHEIGHT","STOPTIME","REPAIRTIME","REPAIR_IS_TO","UNLOADIDFORLOAD","ALLLENGTH","REPORTSHIFT","REPORTDATE","AVHEIGHT","AVGXLOAD","AVGYLOAD","WEIGHT"
    ,(case when worktype like '���������� ����%' then '���������� ����'
else 
(case when worktype like '���%' or worktype like '���.������' then '���. �������������'
else 

worktype end)end) as worktype1
FROM 
    
ugh.V_SHIFTREPORTSADV_month;
