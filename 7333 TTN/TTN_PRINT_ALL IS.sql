PROCEDURE TTN_PRINT_ALL IS       --<- yurmir *** 12.08.2018 *** Pz 6707 <- OLD TTN PRINT !!! 
	cursor print_tn is
    select ID, ID_ZAKAZA, N_ZAKAZA, ID_TIR, ID_ZAK, TIPOVOI_GRUZ, NOMER_ADZ, 
           TOCIKA_VIGRUZKI, KOL_VO_PALLETO_MEST, KOL_VO_ZAKAZOV, KOL_EXEMPLIAR, 
           SUMM_TOVARA_TORG_12, TSENNOSTI, NOMER_PLOMBI, NOMER_PUTEVOGO_UDOST, 
           SURNAME_NAME, CYTI_TO_SHIPMANT, DATE_TO_SHIPMANT, SCET_FACTURA, 
           KOMPLEKT_SERT_UK, ORA_USER_EDIT_ROW_NAME, ORA_USER_EDIT_ROW_DATE, 
           ORA_USER_EDIT_ROW_LOCK, ROW_CREATOR, ROW_CREATION_TIME, ID_TOCIKA_VIGRUZKI, 
           ID_MESTO_VIGRUZKI, MESTO_VIGRUZKI
    from   KB_T_PRINT_TN a   
    where  row_creator= user                          
    ;                      
    rec                KB_T_PRINT_TN%rowtype;                                       
    v_dt_sost          date;         -- плановое время отгрузки из Солво
    v_n_zakaza_cyc     varchar2(38); --№ заказа в СУС
    v_marker           varchar2(38);	
    v_button           NUMBER;
 	 dt_sost             date ;
 	 dt_fact             date ; 
	 n_zakaza_cyc        varchar2(38);
	 V_ADZ_OUT           varchar2(1024);
	 V_ID_ZAK_OUT        varchar2(1000);
	 V_ID_ISP_OUT        varchar2(1000);
	 V_ID_TIP_GRUZA_OUT  varchar2(500);
	 V_ID_MASSA_OUT      varchar2(1024);
	 V_ID_MASSA_OUT_new_tn varchar2(1024);
	 V_ID_MASSA_OUT_ts   varchar2(1024);
	 V_ID_MASSA_OUT_dr   varchar2(1024); 
	 v_KOL_VO_PALLETO    varchar2(1024);
	 V_ID_VODIT_OUT      varchar2(100);
   V_NUMBER_TS_OUT     varchar2(100);
   V_TYPE_TS_OUT       varchar2(100);
--   
--> VVVVVV <- yurmir *** 04.10.2017 ***   
--
   V_ZAO_GK_SEVER      VARCHAR2(1024):= 'ООО  "ГК СЕВЕРТРАНС", Московская обл., Химкинский район, г. Химки, Вашутинское ш., д.20, корп.1';
   v_zao_gk_domod varchar2(1024) :='ООО  "ГК СЕВЕРТРАНС", Московская обл., Ногинский р-н, пос. Обухово, Кудиновское шоссе, д.4';
	 v_SVH varchar2(38);
	 v_adr0 varchar2(200);
--   
--> ^^^^^^ <- yurmir *** 04.10.2017 ***   
--
	 v_per_doc           VARCHAR2(1024);
	 V_inter_swift       VARCHAR2(1024);
	 v_tennosti          VARCHAR2(1024);
	 v_tennosti_ts       VARCHAR2(1024);
	 v_tennosti_dr       VARCHAR2(1024);
	 v_qe                integer;
	 v_count             integer:=0;
	 ret_code            integer;
	 v_massa_mesta       varchar2(1024);
	 v_print_twise       varchar2(4000);
	 v_A41               varchar2(1024) default null;
	 v_A45               varchar2(1024) default null;
	 v_NAIMEN_BANK       varchar2(1024) default null;
	 v_tlf_zak    varchar2(1024);
	 v_tlf_pok    varchar2(1024);
	 v_id_per  varchar2(1024);
	 v_tlf_per  varchar2(1024);--
	 v_error             varchar2(4000);
	 v_VTK_SUM1          varchar2(1024) default null;   --<-- yurmir *** 19/02/2017 ***
	 v_VTK_SUM2          varchar2(1024) default null;   --<-- yurmir *** 19/02/2017 ***
begin     	
	
    --  
    v_marker := '0';
    v_button := Show_Note_Alert('Желаете запустить печать ТН ?', '   Д&а   ', '   Н&ет  '--,' О&тмена '
                 );
	  IF (v_button = ALERT_BUTTON1) THEN
	    --alert_note('Peciati BEFORE');
	     ---------------------------
       -- стандартная обработка --
       ret_code := Def_KEY_COMMIT;
       ---------------------------
			v_marker := '1';
			--forms_ddl('COMMIT');
			for rec in print_tn loop 
			--open print_tn;
		  --loop fetch print_tn into rec; 
		 	--alert_note('Peciati BEFORE loop');	
			v_VTK_SUM1 := rec.ID_TIR;      --<-- ID for KB_TIR    *** yurmir *** 19/02/2017
			v_VTK_SUM2 :=  rec.N_ZAKAZA;   --<-- N_ZAKAZA   *** yurmir *** 19/02/2017
			v_marker := 'DIma_1111';
			  sprut4.UTILITY_PKG_VB.run_procedure_print_ttn(
			                                  rec ,
			                                  dt_sost ,
			                                  dt_fact ,
		                                    n_zakaza_cyc   ,
		                                    V_ADZ_OUT ,
		                                    V_ID_ZAK_OUT ,
		                                    V_ID_ISP_OUT ,
		                                    V_inter_swift ,
		                                    V_ID_TIP_GRUZA_OUT, 
		                                    V_ID_MASSA_OUT ,
		                                    V_ID_VODIT_OUT ,
		                                    V_NUMBER_TS_OUT,
		                                    V_TYPE_TS_OUT  ,
		                                    v_error   
		                                    ,v_tlf_zak
		                                    ,v_tlf_pok
		                                    , v_id_per
		                                    , v_tlf_per);
		   --alert_note('Peciati AFTER loop');
		   v_marker := '1115';
		    if v_error is not null then
		      alert_note( v_error );
		    else
--		  	  alert_note('dt_sost = '||dt_sost||' tlf_zak = '||v_tlf_zak);
		    
		    --ZAPUSKAIU MACROS EXCEL 
		     --alert_note('Run_Excel_Macro BEFORE');
		    --определяю перечень документов ЮНИЛЕВЕР
		    v_per_doc:= 'Накладная № '||rec.nomer_adz ;
		    v_marker := '10';
		    if rec.SCET_FACTURA = '1' then 
		    	v_per_doc:= v_per_doc||', счет/фактура';
		    end if ;
		    if rec.KOMPLEKT_SERT_UK = '1' then 
		    	v_per_doc:= v_per_doc||', комплект сертификатов и УК';
		    end if ;
		    --
		    v_marker := '11';
		    --для паллетомест и веса необходимо писать цифры прописью
		    if rec.KOL_VO_PALLETO_MEST is not null then
		      v_KOL_VO_PALLETO := rec.KOL_VO_PALLETO_MEST||' '||utility_pkg.QuantityNatural2TextRus(to_number(rec.KOL_VO_PALLETO_MEST),'Место,Места,Мест,С');
		    end if ;
		    --
		    v_marker := '12';
		    if V_ID_MASSA_OUT is not null then
		    	
		    	/*		    	 
		    	 V_ID_MASSA_OUT_ts:=substr(V_ID_MASSA_OUT,1,instr(V_ID_MASSA_OUT,'.')-1);      
		    	 if instr(V_ID_MASSA_OUT,'.') > 0 then      
		         V_ID_MASSA_OUT_dr:=  ltrim(substr(V_ID_MASSA_OUT,instr(V_ID_MASSA_OUT,'.')+1),'0');        
		       end if;
		       V_ID_MASSA_OUT := V_ID_MASSA_OUT_ts||' '||utility_pkg.QuantityNatural2TextRus(to_number(V_ID_MASSA_OUT_ts),'килограмм,килограмма,килограмм,М')||' ,'||V_ID_MASSA_OUT_dr; 		        
	        */
	        V_ID_MASSA_OUT_new_tn:=V_ID_MASSA_OUT||' кг.';
	        if instr(V_ID_MASSA_OUT,'.') > 0 then
		    		V_ID_MASSA_OUT_ts:= substr( V_ID_MASSA_OUT,1,instr( V_ID_MASSA_OUT,'.')-1) ;
		    		V_ID_MASSA_OUT_dr:= substr(V_ID_MASSA_OUT,instr(V_ID_MASSA_OUT,'.')+1);
		    		V_ID_MASSA_OUT := V_ID_MASSA_OUT_ts||', '||utility_pkg.QuantityNatural2TextRus(to_number(V_ID_MASSA_OUT_ts),'килограмм,килограмма,килограмм,М')||' ,'||V_ID_MASSA_OUT_dr;
	          	--alert_note('V_ID_MASSA_OUT DROBNOE = '||V_ID_MASSA_OUT);	    	
		    	else 
		    		V_ID_MASSA_OUT := V_ID_MASSA_OUT||', '||utility_pkg.QuantityNatural2TextRus(to_number(V_ID_MASSA_OUT),'килограмм,килограмма,килограмм,М');
		    			--alert_note('V_ID_MASSA_OUT TSELOE = '||V_ID_MASSA_OUT);
		    	end if;	    
		    end if ;  			    
		    
		    v_marker := '13';
		    v_massa_mesta := v_KOL_VO_PALLETO||chr(10)|| V_ID_MASSA_OUT;
		    --    
		    -- определяю ценность груза 
		    v_tennosti := null;
		    if rec.tsennosti ='1' then 
		      v_tennosti := 'Согласно Прайс листа';
		    else 
		    	if rec.SUMM_TOVARA_TORG_12 is not null then 
		    		 	--alert_note('SUMM_TOVARA_TORG_12 is not null  = '||nvl(rec.SUMM_TOVARA_TORG_12,'null'));	    	
		    	  if instr(rec.SUMM_TOVARA_TORG_12,'.') > 0 then
		    		  v_tennosti_ts:= substr( rec.SUMM_TOVARA_TORG_12,1,instr( rec.SUMM_TOVARA_TORG_12,'.')-1) ;
		    		  v_tennosti_dr:= substr(rec.SUMM_TOVARA_TORG_12,instr(rec.SUMM_TOVARA_TORG_12,'.')+1);
		    		  v_tennosti := v_tennosti_ts||', '||utility_pkg.QuantityNatural2TextRus(to_number(v_tennosti_ts),'руб.')||' ,'||v_tennosti_dr;
	            --	alert_note('SUMM_TOVARA_TORG_12 DROBNOE = '||v_tennosti);	    	
		    	  else 
		    		  v_tennosti := rec.SUMM_TOVARA_TORG_12||', '||utility_pkg.QuantityNatural2TextRus(to_number(rec.SUMM_TOVARA_TORG_12),'руб.');
		    		  --	alert_note('SUMM_TOVARA_TORG_12 TSELOE = '||v_tennosti);
		    	  end if;
		    	end if;
		    	--v_tennosti := v_tennosti_ts||', '||utility_pkg.QuantityNatural2TextRus(to_number(v_tennosti_ts),'руб.')||' ,'||v_tennosti_ts;
		    	--
		    	--v_tennosti :=substr(rec.SUMM_TOVARA_TORG_12,instr(rec.SUMM_TOVARA_TORG_12,'.')+1) 
		    	--||' '||utility_pkg.QuantityNatural2TextRus(to_number(substr( rec.SUMM_TOVARA_TORG_12,1,instr( rec.SUMM_TOVARA_TORG_12,'.')-1)),
		    	--'килограмм,килограмма,килограмм,М')||' ,'
		    	--||ltrim(substr(rec.SUMM_TOVARA_TORG_12,instr(rec.SUMM_TOVARA_TORG_12,'.')+1),'0');
		    	--alert_note('SUMM_TOVARA_TORG_12 = '||v_tennosti);
		    	--if instr(to_char(rec.SUMM_TOVARA_TORG_12),'.')>0 then
		    	--end if ; 
		    	--v_tennosti := rec.SUMM_TOVARA_TORG_12;
		    end if;
		    --
		    v_marker := '19';
		    -- Для ВОЕНТЕЛЕКОМ-а оставляю поля в файле пустыми A41 и A45 и А26-v_per_doc
		    begin
		    	select n_eng into v_A41 from kb_zak where id=rec.ID_ZAK;
		    exception when others then v_A41:=null;
		    end;	
		    if /*rec.ID_ZAK in('0102252197',  -- ВОЕНТЕЛЕКОМ
		    	               '0102253621',  -- ООО "КОМПАНИЯ НОВЫЙ БИЗНЕС"
		    	               '0102252663'   -- ВОЕНТЕЛЕКОМТЕСТ
		    	               )*/ 
		    	           v_A41='VTK GROUP'    then
		    	               V_ZAO_GK_SEVER := v_zao_gk_domod;
		    	   -- типовой груз  		    	       
		    begin
					if upper(V_ID_MASSA_OUT)='0, НОЛЬ КИЛОГРАММ' then V_ID_MASSA_OUT:= null; end if;
		    	rec.TIPOVOI_GRUZ := 	V_ID_TIP_GRUZA_OUT ; 
				end;          
		    	v_A41 := ' ';
		    	v_A45 := ' ';
		    	v_per_doc :=' ';

		    -- заявка 6102 Полякова Т. для Икеи меняю Грузоотправителя
		    elsif rec.ID_ZAK in ('0102254951'-- ИКЕА
		    	                  ) then 
		    	V_ID_ZAK_OUT := 'ЗАО "ГК "СЕВЕРТРАНС, РФ, 141400, Московская область, г. Химки, Вашутинское шоссе, дом 20, корпус 1';
		    end if;
		    -- Заявка  6168 Лукина Новая ТРН
		    if rec.id_zak is not null then 
		      begin
		    	  v_marker:='19.1'; 
		    	  select    a.NAIMEN||' '
							        ||decode(a.ur_adr,null,null,a.ur_adr||' ' )
							        ||a.brs ||' '
							        ||a.ks||' '
							        ||a.rs
					  into  v_NAIMEN_BANK  
						from  kb_zak a 
						where a.id = rec.ID_ZAK  
						;		    	  
		      exception when others then 
		      	 alert_note('Внимание ошибка обработки Печати Marker = '||v_marker|| ' '||sqlerrm);
		      end;		      
		    end if ;
		    --
		    -- делаю цикл по кол-ву экземпляров
		    v_marker := '20';
		    v_qe := 1; --rec.KOL_EXEMPLIAR ;
		    v_count:=0;
		    for z in 1..v_qe loop
		    	v_count:=v_count+1;
				--
				--> VVVVVVVVVVVVVVVVVVVVVVVVVVVVVV --- счет суммы из MX1_3 -- yurmir *** 19/02/2017 ***
				--
				SELECT
						to_char(sum(UNITS * PRC)), to_char(count(*)) into v_VTK_SUM1, v_VTK_SUM2
				FROM
				(
				---> BEGIN --- запрос из отчета << ВТК MX1_3 >>
				SELECT
				 min( decode( substr( ltrim( s1.name ),1,1 )
							 , '(' , ltrim(substr(ltrim(s1.name), instr(s1.name,')',2)+1) ) 
							 , s1.name )
					 ) 
				AS  name
				, '="' || DECODE ( INSTR ( (min(S.article)), '-'),
								   0, (min(S.article)),
								   SUBSTR ( (min(S.article)), 1, INSTR ( (min(S.article)), '-') - 1)
						  ) ||'"' AS article
				,
					SUM(l.qty) / decode(nvl(s1.mu_units,0),0,1, s1.mu_units)
				  * min( decode(  sign((nvl(s.PALLET_STACK_SIZE,1) - 2)*(998 - nvl(s.PALLET_STACK_SIZE,1))) 
								  , -1, 1
								  , nvl(s.PALLET_STACK_SIZE,1)))
				AS  units
				,MIN(NVL(s1.INTERNAL_PRICE,0)) AS prc
				FROM
                      kb_sost ss, kb_spros sp,kb_spros sp1
					  ,det_doc_to_host  l
					  ,sku  s
					  ,sku s1
				 WHERE
					   ----------- VVVVVV ---- поиск исходного sost.ID --  yurmir *** 19/02/2017 ***
					   ss.id in (
									select
										ss.id SS_id ---, ss.dt_sost SS_dt, ss.sost_prm SS_PRM, sp.n_zakaza ZAK_N, zk.n_zak ZAK_TITL, zk.n_eng VTK, ss.id_sost
									from
										kb_spros sp, kb_sost  ss, kb_zak zk
									where
										sp.id_tir  = v_VTK_SUM1 --<-- ID for KB_TIR
									and sp.n_zakaza =  v_VTK_SUM2   --<-- N_ZAKAZA
									and ss.id_obsl =  sp.id
									and zk.id = sp.id_zak
									and ss.id_sost in ('KB_USL60177','KB_USL60174','KB_USL60173') -- 4104 Фактическая отгрузка товара из СОХ
									and zk.n_eng like '%VTK%GROUP%'
					   )
					   ----------- ^^^^^^ ---- поиск исходного sost.ID --  yurmir *** 19/02/2017 ***
				   and sp.id= ss.id_obsl and sp1.npost(+) = sp.npost
				   and ss.id_sost in ('KB_USL60177','KB_USL60174','KB_USL60173')             -- 4104 Фактическая отгрузка товара из СОХ
				   and (
					   l.ORDER_ID =  nvl(sp1.id,ss.id_obsl) AND ss.id_sost = ('KB_USL60177') -- 4104 Фактическая отгрузка товара из СОХ
				   and l.TAGNM = 'order_detail_info'                                         -- для ЗАКАЗОВ в поле TAGNM если RECEIVE_COMPLETE_DETAIL
					or l.inc_id= nvl(sp1.id,ss.id_obsl) AND ss.id_sost <> ('KB_USL60177')    -- 4102 Фактическая поставка товара на СОХ
				   and l.TAGNM = 'receive_complete_detail'                                   -- для ЗАКАЗОВ в поле TAGNM если RECEIVE_COMPLETE_DETAIL
					   )
				   and l.SOLVO_SKU_ID   = s.id and l.QTY > 0 and S1.HOLDER_ID = S.HOLDER_ID
				   and S1.sku_id = DECODE( INSTR((S.sku_id),'-')
										   ,0,(S.sku_id),
										   SUBSTR((S.sku_id),1,INSTR((S.sku_id),'-')- 1)
										   )
				 GROUP BY s1.sku_id, s1.mu_units
				---> END --- запрос из отчета << ВТК MX1_3 >>
				);
				if v_VTK_SUM1 is not null then
					v_tennosti := ' Общая стоимость заказа   '|| v_VTK_SUM1 ||'   руб. ';
				end if;
				--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^--- счет суммы из MX1_3 -- yurmir *** 19/02/2017 ***
--   
--> VVVVVV <- yurmir *** 06.10.2017 ***   
--
begin
	select ID_SVH into v_SVH from kb_tir t where t.id = rec.ID_TIR
	;
	select  ( min(z1.p_ind) || ', ' || min(z1.ur_adr) ) into v_adr0
	  from kb_zak z1,  sv_hvoc sl 
	  where z1.id=sl.val_full and sl.hvoc_val_id='SL_REP96061' and sl.val_short= v_SVH
	;
	select (
		   z.naimen || ', ' || nvl(v_adr0, z.p_ind || ', ' || z.ur_adr)
		|| decode(z.tlf,null,null,', '|| z.tlf)||decode(z.fax,null,null,', '|| z.fax)
		   ) into V_ZAO_GK_SEVER
	from   kb_zak z
	where   z.id = '0102292445'
	;
exception when others then
   V_ZAO_GK_SEVER := 'Общество с ограниченной ответсвенностью "ГК "СЕВЕРТРАНС" (ООО "ГК "СЕВЕРТРАНС"), 141402, Московская область, г. Химки, квартал Клязьма, владение 1Д., (499) 753-77-25, (495) 502-87-70';
end;
--   
--> ^^^^^^ <- yurmir *** 06.10.2017 ***   
--

		Excel_ole( --'RAPTTN4Print'
			NVL(UPPER(n_zakaza_cyc ),    ' --- ') 
			,'Экземпляр№ '||to_char(v_count)                    		                 
				,'Дата '||NVL(to_char(trunc(dt_sost),'dd.mm.rrrr'), ' --- ') 
				,NVL(to_char(dt_sost,'dd.mm.rrrr hh24.mi'), ' --- ') 
				,NVL(to_char(dt_fact,'dd.mm.rrrr hh24.mi'), ' --- ')        
				,'№ '||UPPER(NVL(v_adz_out,rec.nomer_adz ))
				,NVL(UPPER(V_ID_ZAK_OUT ),    ' --- ')
				,NVL(REC.TOCIKA_VIGRUZKI ,' --- ')
				--,NVL(UPPER(V_ID_ISP_OUT ),    ' --- ')
				,NVL(UPPER(V_inter_swift ),    ' --- ')
				,NVL(UPPER(rec.TIPOVOI_GRUZ ),    ' --- ')
				,NVL(UPPER(v_KOL_VO_PALLETO ),    ' --- ')
				,NVL(UPPER(V_ID_MASSA_OUT),    ' --- ')				           
				,NVL(UPPER(v_per_doc ),    ' --- ')
				,NVL(UPPER(rec.NOMER_PLOMBI ),    ' --- ')
				,NVL(UPPER(V_ID_MASSA_OUT_new_tn),    ' --- ')		           		                 
				,NVL(to_char(trunc(rec.DATE_TO_SHIPMANT),'dd.mm.rrrr'), ' --- ')
				,NVL(V_ID_VODIT_OUT ,     ' --- ') 
				,NVL(UPPER(V_TYPE_TS_OUT ),     ' --- ') 
				,NVL(UPPER(V_NUMBER_TS_OUT ),     ' --- ') 
				,NVL(UPPER(rec.NOMER_PUTEVOGO_UDOST ),    ' --- ') 
				,' '--,UPPER(rec.SURNAME_NAME )
				,NVL(UPPER(v_tennosti ),   ' --- ')
				,NVL(to_char(trunc(dt_sost),'dd.mm.rrrr'), ' --- ')||' '||UPPER(V_inter_swift)-- list 2  A4   9. Информация о принятии заказа (заявки) к исполнению
				,NVL(UPPER(v_A41),   ' --- ')
				,NVL(UPPER(v_A45),   ' --- ')
				,NVL(rec.MESTO_VIGRUZKI,NVL(REC.TOCIKA_VIGRUZKI ,' --- '))
				,NVL(UPPER(V_ZAO_GK_SEVER ),    ' --- ')	       
				,NVL(UPPER(rec.KOL_VO_PALLETO_MEST)||' мест',' --- ')       
				,NVL(UPPER(v_NAIMEN_BANK),' --- ')   
						,nvl(v_tlf_zak,' --- ')
						,nvl(v_tlf_pok,' --- ')
				); 

				end loop;
				--
				v_marker := '25';
		    --

--> *** yurmir *** 12.08.2018 *** pz6707 ***

		  :SURNAME_NAME:= :SURNAME_NAME;
		   ---------------------------
       -- стандартная обработка --
       ret_code := Def_KEY_COMMIT;
       ---------------------------
		    --
		    end if;
		 --   	
		 end loop;
		 -------------------------
     --стандартная обработка--
             Def_KEY_EXIT;
     -------------------------
  end if;
exception when others then 
 	alert_note('Внимание ошибка обработки Печати Marker = '||v_marker|| ' '||sqlerrm);
end;