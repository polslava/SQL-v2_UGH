
  CREATE OR REPLACE FORCE VIEW "UGH"."V_REPORT_UOGR_SHIFT1" ("SHOVID", "VOLUME_10", "TRIPS_10", "VOLUME_12", "TRIPS_12", "VOLUME_15", "TRIPS_15", "VOLUME_17", "TRIPS_17", "SHIFT", "SHIFT_PLAN") AS 
  select 
shovid 
    , volume_10
    , trips_10 
    , volume_12
    , trips_12 
    , volume_15
    , trips_15 
    /*, volume_16
    , trips_16 */
    , volume_17
    , trips_17 
        , shift 
        ,shift_plan 
 from table (ugh.pac_uogr.get_UOGR_Rep(
--:P37_Date
ugh.f_get_shiftdate()

))
where shift = 1
and shovid not in ('итого','за час')
union
select 
shovid 
    , volume_10
    , trips_10 
    , volume_12
    , trips_12 
    , volume_15
    , trips_15 
    /*, volume_16
    , trips_16 */
    , volume_17
    , trips_17 
        , shift 
        ,shift_plan 
from table (ugh.pac_uogr.get_UOGR_Rep(
--:P37_Date
ugh.f_get_shiftdate()

))
where shift = 1
and shovid in ('итого','за час')

union
select 
shovid || ' за интервал'

, volume_10d, null
    , volume_12d , null
    , volume_15d , null
    /*, volume_16d , null*/
    , volume_17d , null
            , shift 
        ,null
from table (ugh.pac_uogr.get_UOGR_Rep(
--:P37_Date
ugh.f_get_shiftdate()

))
where shift = 1
and shovid not in ('итого','за час');
