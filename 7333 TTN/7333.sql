select * from kb_zak where id_klient =990;
-- �� 988988 ������������ ��������
select id,id_svh from kb_tir where id='01022983946';
select * from sv_hvoc where val_id='KB_SVH53972'; -- �������� id_svh
select * from sv_hvoc where voc_id='KB_SVH' and val_state='Active'; -- ��������
-- KB_SVH95476	��� (����-����)
select * from sv_hvoc where voc_id='SL_REP'; --������� ������� 
select * from sv_hvoc where val_id='SL_REP96061';--�� ��� ����-������ �� �� ��������� ����������

select * from sv_hvoc where val_full like '%R_VB_SVH%';
select * from sv_hvoc where val_id='SL_REP96061';
select * from sv_hvoc where voc_id = 'SL_REP';

select  ( min(z1.p_ind) || ', ' || min(z1.ur_adr) ) ---into v_adr0
  from kb_zak z1,  sv_hvoc sl 
  where z1.id=sl.val_full and sl.hvoc_val_id='SL_REP96061';-- and sl.val_short= v_SVH


SELECT t.id_svh,t.*
--INTO v_svh
FROM kb_tir t
WHERE t.id = '01022983946';


select z.id_svh,z.ur_adr from kb_zak z,kb_tir t
where  z.id_svh = t.id_svh and z.id_klient = 988988 and t.id = '01022983946'; --rec.id_tir;
select z.id_svh,z.ur_adr from kb_zak z where z.id_klient = 988988;


SELECT ( z.naimen || ', ��� '||z.inn_zak|| ', ' || nvl(null, z.p_ind || ', ' || z.ur_adr) || decode(z.tlf, NULL, NULL, ', ' || z.tlf) )
--INTO v_zao_gk_sever
FROM kb_zak z
WHERE z.id = '0102292445'; --id_klient =990


select * from kb_spros where n_gruz='HELLMAN_SKU';
select * from kb_sost where id_obsl ='01023541487';
select * from sv_hvoc where val_id IN ('KB_USR92734', 'KB_USR99992');
/*
01023541487
01023544257
01023547704
01023561918
*/