--#1609877
SELECT distinct
     a.name --??? ?????
--     ||';'|| s.article --??? ??????
	  ||';'|| CASE WHEN instr(s.article,'"') > 0 THEN '"'|| REPLACE(s.article, '"', '""')||'"' ELSE s.article END 
--     ||';'|| s.NAME --?????
	  ||';'|| CASE WHEN instr(s.name,'"') > 0 THEN '"'|| REPLACE(s.name, '"', '""')||'"' ELSE s.name END 
     ||';'|| (select bi.name from billing_class bi where s.billing_class=bi.id)--??? ??????
     ||';'|| case a.status when 'A' then '????????' else '???????' end --??????
     ||';'|| a.rcn_id --??
     ||';'|| inc1.id --??
     ||';'|| a.order_id --????? ?????
     ||';'|| inc1.client_doc_num --???????? ???????
     ||';'|| (select lc.name from LOCATION lc where lc.id=a.Loc_id)--??????
     ||';'|| (select lcc.name from LOCATION lcc where lcc.id=a.real_loc_id)--???????? ??????
     ||';'|| ci.description  --????????
     ||';'|| (select cii.description from code_info cii where ci.code_id=cii.id) --??.????????
     ||';'|| (select pt.name from PACK_TYPE pt where pt.id=ci.pack_type) --??? ????????
     ||';'|| case when a.handle_type=1 then 0 when a.handle_type=3 then a.qty else a.qty_of_barcode end --???-?? ???????
     ||';'|| a.units --???-??
     ||';'|| to_char(a.production_date,'dd.mm.yyyy hh24:mi') --???? ????????????
     ||';'||case when to_char(date_utils.ctime2date(a.realization_date),'dd.mm.yyyy')= '01.01.1970'  then null
            else to_char(date_utils.ctime2date(a.realization_date,'GMT+3'),'dd.mm.yyyy hh24:mi') end --???? ????????
     ||';'|| to_char(round(a.cube/1000000,2),'9999999D9999','NLS_NUMERIC_CHARACTERS=,.') --?????
     ||';'||  to_char(a.weight,'9999999D9999','NLS_NUMERIC_CHARACTERS=,.') --???
     ||';'||  to_char( a.real_weight,'9999999D9999','NLS_NUMERIC_CHARACTERS=,.') --??????????? ???
     ||';'|| case a.category
             when 4 then '????'
             when 5 then '??????.'
             else '?????' end --?????????
     ||';'|| replace(a.marker,'"','""')--||'"' --??????
     ||';'|| a.serial_num  --???????? ?????
     ||';'|| a.lot as body_rep,
     ks.id --????????? ??????
  FROM sprut4.kb_sost@gs_gwi3.kvt.local  ks
--   join archive_incomings inc1 on inc1.id = ks.id_du
--   join archive_rcn_detail rd on rd.inc_id = inc1.id
--   join archive_loads a on a.rcn_id = rd.rcn_id
   join incomings inc1 on inc1.id = ks.id_du
   join rcn_detail rd on rd.inc_id = inc1.id
   join loads a on a.rcn_id = rd.rcn_id
   join sku s on a.sku_id=s.id
   join code_info ci on a.barcode_id=ci.id
	inner join sprut4.kb_spros@gs_gwi3.kvt.local sp on ks.id_obsl = sp.id
	inner join sprut4.kb_zak@gs_gwi3.kvt.local z on sp.id_zak= z.id
  where ks.id_sost = ('KB_USL60174')
--  and ks.row_creation_time > sysdate - 3
--  AND instr(s.name,'"') > 0
  and sp.id_zak='0102310351'
  and ks.id='0102676174457'
  ;