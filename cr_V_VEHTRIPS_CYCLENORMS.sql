
  CREATE OR REPLACE FORCE VIEW "UGH"."V_VEHTRIPS_CYCLENORMS" ("TRIPCOUNTER", "VEHID", "TIMELOAD", "TIMEUNLOAD", "GMTTIMELOAD", "GMTTIMEUNLOAD", "FUELLOAD", "FUELUNLOAD", "WEIGHT", "LENGTH", "AVSPEED", "UNLOADLENGTH", "SHOVID", "UNLOADID", "LOADTYPE", "MOVETIME", "XLOAD", "YLOAD", "XUNLOAD", "YUNLOAD", "WORKTYPE", "AREA", "VEHCODE", "SHOV_ID", "UNLOAD_ID", "LOADTYPE_ID", "WORKTYPE_ID", "AREA_ID", "HYDROSYSTEMWEIGHT", "TIME_INSERTING", "UNLOADIDFORLOAD", "ZLOAD", "ZUNLOAD", "WRATE", "VRATE", "REDUCEDLENGTH", "ISAREAINTERSECT", "BUCKETCOUNT", "LOADHEIGHT", "UNLOADHEIGHT", "VOLUME", "nedogruz_tn", "nedogruz_percent", "NEDOGRUZ", "TIMELOAD_HOUR_T", "TIMELOAD_HOUR", "DATESHIFT_HOUR", "DATESHIFT_HOUR_T", "DUMPTUCK", "TRIP", "SHIFTHOUR_HALF_T", "SHIFTHOUR_HALF", "DUMPTRUCK_MODEL", "SHOVEL_MODEL", "STOP_LOADING", "STOP_WAITLOAD", "STOP_WAITTRUCK") AS 
  select vt."TRIPCOUNTER",vt."VEHID",vt."TIMELOAD",vt."TIMEUNLOAD",vt."GMTTIMELOAD",vt."GMTTIMEUNLOAD",vt."FUELLOAD",vt."FUELUNLOAD",vt."WEIGHT",vt."LENGTH",vt."AVSPEED",vt."UNLOADLENGTH",vt."SHOVID",vt."UNLOADID",vt."LOADTYPE",vt."MOVETIME",vt."XLOAD",vt."YLOAD",vt."XUNLOAD",vt."YUNLOAD",vt."WORKTYPE",vt."AREA",vt."VEHCODE",vt."SHOV_ID",vt."UNLOAD_ID",vt."LOADTYPE_ID",vt."WORKTYPE_ID",vt."AREA_ID",vt."HYDROSYSTEMWEIGHT",vt."TIME_INSERTING",vt."UNLOADIDFORLOAD",vt."ZLOAD",vt."ZUNLOAD",vt."WRATE",vt."VRATE",vt."REDUCEDLENGTH",vt."ISAREAINTERSECT",vt."BUCKETCOUNT",vt."LOADHEIGHT",vt."UNLOADHEIGHT",vt."VOLUME",vt."nedogruz_tn",vt."nedogruz_percent",vt."NEDOGRUZ",vt."TIMELOAD_HOUR_T",vt."TIMELOAD_HOUR",vt."DATESHIFT_HOUR",vt."DATESHIFT_HOUR_T",vt."DUMPTUCK",vt."TRIP"
, vt.shifthour_half_t
, vt.shifthour_half
, dt.model as dumptruck_model
, s.model as shovel_model
, round((cn_1.value)/60,4) as stop_loading
, round((cn_2.value)/60,4) as stop_waitload
, round((cn_3.value)/60,4) as stop_waittruck
    from ugh.v_vehtrips vt
    left join dispatcher.dumptrucks dt
        on vt.vehid = dt.vehid
    left join dispatcher.shovels s
        on vt.shovid = s.shovid
    left join ugh.cycle_norm cn_1
        on s.model = cn_1.shovmodel and dt.model = cn_1.dumptruckmodel
        and cn_1.cycle_norm_type_id =1
    left join ugh.cycle_norm cn_2
        on s.model = cn_2.shovmodel and dt.model = cn_2.dumptruckmodel
        and cn_2.cycle_norm_type_id =2
    left join ugh.cycle_norm cn_3
        on s.model = cn_3.shovmodel and dt.model = cn_3.dumptruckmodel
        and cn_3.cycle_norm_type_id =3;
