SELECT distinct
     a.name --имя груза
     ||';'|| s.article --код товара
     ||';'|| s.NAME --Товар
     ||';'|| (select bi.name from billing_class bi where s.billing_class=bi.id)--Тип товара
     ||';'|| case a.status when 'A' then 'Доступен' else 'Отобран' end --Статус
     ||';'|| a.rcn_id --ПО
     ||';'|| inc1.id --УП
     ||';'|| a.order_id --заказ нужен
     ||';'|| inc1.client_doc_num --документ клиента
     ||';'|| (select lc.name from LOCATION lc where lc.id=a.Loc_id)--ячейка
     ||';'|| (select lcc.name from LOCATION lcc where lcc.id=a.real_loc_id)--реальная ячейка
     ||';'|| ci.description  --упаковка
     ||';'|| (select cii.description from code_info cii where ci.code_id=cii.id) --вн.упаковка
     ||';'|| (select pt.name from PACK_TYPE pt where pt.id=ci.pack_type) --вид упаковки
     ||';'|| case when a.handle_type=1 then 0 when a.handle_type=3 then a.qty else a.qty_of_barcode end --кол-во коробок
     ||';'|| a.units --кол-во
     ||';'|| to_char(a.production_date,'dd.mm.yyyy hh24:mi') --дата производства
     ||';'||case when to_char(date_utils.ctime2date(a.realization_date),'dd.mm.yyyy')= '01.01.1970'  then null
            else to_char(date_utils.ctime2date(a.realization_date,'GMT+3'),'dd.mm.yyyy hh24:mi') end --срок годности
     ||';'|| to_char(round(a.cube/1000000,2),'9999999D9999','NLS_NUMERIC_CHARACTERS=,.') --объём
     ||';'||  to_char(a.weight,'9999999D9999','NLS_NUMERIC_CHARACTERS=,.') --вес
     ||';'||  to_char( a.real_weight,'9999999D9999','NLS_NUMERIC_CHARACTERS=,.') --фактический вес
     ||';'|| case a.category
             when 4 then 'Брак'
             when 5 then 'Неконд.'
             else 'Норма' end --категория
     ||';'|| replace(a.marker,'"','""')--||'"' --маркер
     ||';'|| a.serial_num  --серийный номер
     ||';'|| a.lot as body_rep,
     ks.id --товариная партия
  FROM sprut4.kb_sost@gs_gwi3.kvt.local  ks
   join incomings inc1 on inc1.id = ks.id_du
   join rcn_detail rd on rd.inc_id = inc1.id
   join loads a on a.rcn_id = rd.rcn_id
   join sku s on a.sku_id=s.id
   join code_info ci on a.barcode_id=ci.id
  where ks.id_sost = ('KB_USL60174') and ks.row_creation_time > sysdate - 3