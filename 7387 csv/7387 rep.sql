select sl.val_full, zz.id z_id, zz.n_zak, zz.naimen, zz.id_wms,sr.id code,sr.report_code, sd.*
from sv_hvoc sl
inner join sc_reports sr on sr.REPORT_CODE =sl.tools
inner join sc_srv_data sd on sd.id_type=sl.val_id and sd.data is not null
inner join kb_zak zz on sd.id_zak=zz.id
where sl.hvoc_val_id='SCSRVD97648'
--and report_code='ST_OPT';
;

SELECT * FROM sv_hvoc WHERE val_id='SCSRVD82180'; --Информационная рассылка

SELECT * FROM sv_hvoc WHERE hvoc_val_id='SCSRVD97648'; --по времени
SELECT * FROM sv_hvoc WHERE val_id='SCSRVD97648';

SELECT * FROM sv_hvoc WHERE val_id='SCSRVD96661'; -- по событиям
SELECT * FROM sv_hvoc WHERE VOC_id='SCSRVD' and val_short='ФЗ4102';

-- ФЗ4102
select * from sc_reports where name like '%факту закрытия поставки%';
select * from sc_reports where report_code='INC_PZ'; --Текущий сток кратко - EML
select * from sc_query where report_id=9546;

select 'Имя груза;Код товара;Товар;Тип товара;Статус;ПО;УП;Заказ;Документ клиента;Ячейка;Реальная ячейка;Упак.;Вн.упак.;Вид упаковки;К-во коробок;Кол-во;Дата произв-ва;Срок годн.;Объем (м3);Вес;Фактический вес;Категория;Маркер;Серийный номер;Товарная партия' as P1
from dual
union all
  select t.body_rep
  from wms.view_rep_fz4102@wms3 t where t.id = :ID;