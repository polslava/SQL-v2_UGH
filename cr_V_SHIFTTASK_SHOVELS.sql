
  CREATE OR REPLACE FORCE VIEW "UGH"."V_SHIFTTASK_SHOVELS" ("SHOV_ID", "TASK_DATE", "SHIFT", "TABEL_NUM", "DRIVER_FIO", "AREA", "WORK_TYPE") AS 
  select sst.shov_id, sst.task_date, sst.shift, sst.tabel_num
    ,sd.famname||' '||substr(sd.firstname,1,1)||'.'||substr(sd.secname,1,1)||'.' as Driver_fio
    ,sstd.area, sstd.work_type
    from dispatcher.shov_shift_tasks sst
    left join dispatcher.shovdrivers sd on sd.tabelnum = sst.tabel_num
    left join dispatcher.shov_shift_task_details sstd on sstd.task_id = sst.id
    where --sst.id=162456
        sst.task_date = getcurshiftdate(0, sysdate)
        and sst.shift = getcurshiftnum(0, sysdate);
