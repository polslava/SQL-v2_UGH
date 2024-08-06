
  CREATE OR REPLACE FORCE VIEW "UGH"."V_STP_SHOVELS_STOPPAGES_1M" ("NAME", "VEHTYPE", "CONTROLID", "TIMESTOP", "TIMEGO", "STOPPAGETYPE", "VEHID", "H_STOP", "STOPDATE", "STOPSHIFT") AS 
  select ust.name, 'Экскаватор' vehtype, sh.controlid, mstp.timestop, mstp.timego 
            ,ustc.name as stoppagetype /*Моя  доработка: 20220625*/
            , mstp.vehid
            , round((mstp.timego-mstp.timestop)*24,2) as h_stop
            , to_char(mstp.timestop,'dd') as stopdate
            , ugh.f_get_shiftnum(mstp.timestop) as stopshift
          from dispatcher.manualstoppages_shov mstp
          inner 
          join dispatcher.userstoppagetypes_shovels ust on ust.code=mstp.typeid
          inner 
          join dispatcher.shovels sh on sh.shovid=mstp.vehid 
          left join dispatcher.repairsheets_shov rss on rss.rscounter = mstp.repairsheetcounter /*Моя  доработка: 20220625*/
        left join dispatcher.userstoppagecategories_shovels ustc on ustc.id = ust.categoryid /*Моя  доработка: 20220625*/
          
          
          
          /*where sysdate between timestop and timego*/
          where timestop between /*sysdate-30*/
            to_date('01'||to_char(sysdate, 'mm.yyyy'),'dd.mm.yyyy')
            and sysdate+1
          and ust.code not in (1761, 1252);
