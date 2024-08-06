
  CREATE OR REPLACE FORCE VIEW "UGH"."V_CH_MESSAGES" ("ID", "USER_FROM", "USER_TO", "GROUP_FROM", "GROUP_TO", "MESSAGE", "MESTIME") AS 
  select 
m.ID,
--m.ID_USER_FROM,
--m.ID_USER_TO,
u1.user_name as USER_FROM,
u2.user_name as USER_TO,
--m.ID_GROUP_FROM,
--m.ID_GROUP_TO,
g1.group_name as GROUP_FROM,
g2.group_name as GROUP_TO,
m.MESSAGE,
m.MESTIME
from ugh.ch_messages m
left join ugh.ch_users u1 
    on u1.id_user = m.id_user_from
left join ugh.ch_users u2
    on u2.id_user = m.id_user_to
left join ugh.ch_group g1
    on g1.id_group = m.ID_GROUP_FROM
left join ugh.ch_group g2
    on g1.id_group = m.ID_GROUP_TO;
