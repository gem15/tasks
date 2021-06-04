PROCEDURE insert_tab_param  IS
  CURSOR TIR(ID_TIR_IN VARCHAR2) IS 
    select a.id_pok ,a.ID_ZAK, 1 /*count(*)*/ quantity, a.n_zakaza n_zakaza
    from   kb_spros a
    where  A.id_tir = ID_TIR_IN
--    group by A.id_pok,a.ID_ZAK
    ;
  CURSOR N_ZAKAZ( TOCIKA_VIGR VARCHAR2, ID_TIR_FOR_INS VARCHAR2) IS
    select n_zakaza
    from  kb_spros 
    where id_pok = TOCIKA_VIGR -- poluciatel 
    and   id_tir = ID_TIR_FOR_INS --tir
    ;
  ID_TIR_IN    VARCHAR2(38);
  CK_LOOP      PLS_INTEGER:=0;
  CK_GIRO_n_adz      BOOLEAN ;
  CK_GIRO_n_zak      BOOLEAN ;
  v_n_zakaza   kb_t_print_tn.n_zakaza%type;
  v_tip_gruz   VARCHAR2(500);
  v_n_adz      kb_t_print_tn.NOMER_ADZ%type;
  v_n_adz_out  kb_t_print_tn.NOMER_ADZ%type;
  v_TOCIKA_VIGRUZKI   kb_t_print_tn.TOCIKA_VIGRUZKI%type;
  v_ID_MESTO_VIGRUZKI kb_t_print_tn.ID_MESTO_VIGRUZKI%type;
  v_MESTO_VIGRUZKI    kb_t_print_tn.MESTO_VIGRUZKI%type;
  v_marker     varchar2(1000);
  v_pm_quant   varchar2(100);
  v_error      varchar2(4000);
  v_exit       exception ;
  v_VTK   varchar2(100);         --<-- yurmir *** 24/02/2017 ***
  --
  the_username varchar2(100);
  the_password varchar2(100);
  the_connect  varchar2(100);
  ret_code     PLS_INTEGER;	
  FunTitle     varchar2(1024) default 'insert_tab_param'; 
  text_var     varchar2(1024);
  --  	
BEGIN
-->	alert_note(' Old prc -> TYPE !!! ->'||:GLOBAL.v_TTN);     --<- yurmir *** 08.08.2018 
  IF :PARAMETER.PAR_FOR_PRINT_TN IS NULL THEN
  	--if Name_In('global.id_tir_prin_tn') is null then 
    ALERT_NOTE ('Параметр ID_TIRA = NULL');
  ELSE
  	--ALERT_NOTE(':PARAMETER.PAR_FOR_PRINT_TN = '||:PARAMETER.PAR_FOR_PRINT_TN);
  	--
  	ID_TIR_IN:=:PARAMETER.PAR_FOR_PRINT_TN;   --  :PARAMETER.PAR_FOR_PRINT_TN;
  	--ALERT_NOTE('ID_TIR_IN = '||ID_TIR_IN);
  	v_marker := '1';
    Get_Connect_Info(the_username,the_password,the_connect);
  	DELETE FROM    KB_T_PRINT_TN where row_creator =  the_username ;
  	FOR I IN TIR(ID_TIR_IN) LOOP
  		CK_GIRO_n_adz := TRUE;
  		CK_GIRO_n_zak := TRUE;
  	  FOR Y IN 	N_ZAKAZ( I.id_pok, ID_TIR_IN ) LOOP 
  	  	--определяю номера АДЗ
  	  	--alert_note( 'Y.N_ZAKAZA = '||( Y.N_ZAKAZA));
  	    begin
  	  	  v_marker := '5';
  	  	  select sost.sost_doc       -- (номера АДЗ)
  	  	  into   v_n_adz
					from   kb_spros spros,  kb_sost sost 
					where  spros.n_zakaza in ( Y.N_ZAKAZA)
					and    (sost.id_obsl = spros.id or sost.id_tir = spros.id_tir)
					and    id_sost in (  'KB_USL60175')   -- 4103 планируемая отгрузка товара из СОХ
                                                -- в Новом Солво инфа о АДЗ попадает в поле 
                                                -- SOST_DOC в событие 4103                                              
					;   
					--    
					IF CK_GIRO_n_zak THEN v_n_zakaza :=''''||Y.N_ZAKAZA||'''';CK_GIRO_n_zak := FALSE;
  	  	  ELSE v_n_zakaza := v_n_zakaza||','''||Y.N_ZAKAZA||'''';END IF;
  	  	  --
  	  	  IF CK_GIRO_n_adz THEN v_n_adz_out:=v_n_adz;CK_GIRO_n_adz := FALSE;
  	  	  ELSE v_n_adz_out:= v_n_adz_out||','||v_n_adz;END IF;
  	  	  --
  	    exception 
  	    	when no_data_found then
  	    	  IF CK_GIRO_n_zak THEN v_n_zakaza :=''''||Y.N_ZAKAZA||'''';CK_GIRO_n_zak := FALSE;
  	    	  ELSE v_n_zakaza := v_n_zakaza||','''||Y.N_ZAKAZA||'''';END IF;
  	    	  --
  	    	  IF CK_GIRO_n_adz THEN v_n_adz_out:='Б/Н';CK_GIRO_n_adz:=FALSE;
  	  	    ELSE v_n_adz_out:=  v_n_adz_out||','||'Б/Н';END IF ;
  	    	  --alert_note('Внимание не присутствует номер АДЗ для заказа '||Y.N_ZAKAZA||' соб.4104');
  	    	  --raise v_exit;
  	    	when others then
  	    	  alert_note('Внимание ошибка АДЗ '||SQLERRM);
  	    	 -- raise v_exit;
  	    end;  	  	  	   
  	  	--
    	END LOOP;
      --  
  	  begin
  		   v_pm_quant:=null;  
  		 /*
  	  	 sprut4.UTILITY_PKG_VB.find_kol_vo_PM (
                            v_n_zakaza   ,                                    
                            v_pm_quant     , 
                            v_error        );
        if v_error is not null then
		      alert_note( v_error );
		    end if;  
		   */
      exception 
        WHEN OTHERS THEN null;   	
  	  end;
  	   --
  	-- определяю название типового груза
       v_marker := '10';
  	   BEGIN
  		   --alert_note('I.ID_ZAK = '||I.ID_ZAK);
  	     SELECT nvl(ltrim(rtrim(DATA)),'null') 
  	     into  v_tip_gruz
  	     FROM   SC_SRV_DATA  
  	     WHERE  ID_ZAK = I.ID_ZAK   
  	     AND    ID_TYPE = (select val_id from sv_hvoc where val_short = 'ДГ' and  voc_id = 'SCSRVD' )
  	     ;
  	   EXCEPTION 
  	   	 WHEN NO_DATA_FOUND THEN
  	   	    -- gem 28.05.2021 ALERT_NOTE('Внимание отсутствует название Типового Груза' );
  	   	    v_tip_gruz := 'Типовой Груз';
 -- 	   	    raise v_exit;
  	   END ;
  	-- заявка 6079 Лукина -- 
  	-- Возможность изменения адреса получателя
  	-- Получатель(анкета)данные берутся из поля "Адрес(англ.)" если пусто , то из поля "Юридический адрес ")
      v_marker := '11';
      begin
  	     SELECT N_ENG into v_VTK         --<-- yurmir *** 24/02/2017 ***
         FROM KB_ZAK WHERE ID = i.id_zak
         ;
         IF v_VTK = 'VTK GROUP' THEN     --<-- yurmir *** 24/02/2017 ***
  	        SELECT REPLACE(NAIMEN,CHR(10),null) into v_TOCIKA_VIGRUZKI
            FROM KB_ZAK WHERE ID = i.id_pok ;
         ELSE	         
  	        SELECT   REPLACE (
              NAIMEN||' '||
              DECODE (ADR_ENG, NULL, decode (UR_ADR,null,null,UR_ADR)  ,ADR_ENG  ),
              CHR (10),
              null
              )
              into   v_TOCIKA_VIGRUZKI
            FROM KB_ZAK WHERE ID = i.id_pok ;
          END IF;         
         --alert_note('v_TOCIKA_VIGRUZKI = '||v_TOCIKA_VIGRUZKI);
      exception when others then null;
      end;
    -- 
    -- Заявка  6128 Необходимо в контактной информации внести новый код - 
    -- - пункт разгрузки, а в поле данные будет прописываться адрес. 
    -- Данный адрес должен подтягиваться в поле  пункт разгрузки в ТТн и ТрН.      
  	--
  	v_marker := '12';
  	begin
  		select rtrim(ltrim(replace(sc.data,chr(10),'')))
  		into   v_MESTO_VIGRUZKI
      from   sc_srv_data sc
      where  sc.id_zak = i.id_pok -- id poluceatelia
      and    sc.id_type = 'SCSRVD94994' -- ДТ   Адрес точки выгрузки 
      ;
    --
      --alert_note('Адрес точки выгрузки = '||v_MESTO_VIGRUZKI); 
    --  
  	exception when Too_Many_rows then 
  		ALERT_NOTE('Внимание у получателя указан  более чем 1 пункт разгрузки в контактной информации!!!!!' );
  		when others then null;
  	end;
  	--
  	   v_marker := '15';
  		  INSERT /*+ APPEND */ INTO KB_T_PRINT_TN(
  		                       ID_TOCIKA_VIGRUZKI  ,
  		                       TOCIKA_VIGRUZKI  ,
  		                       id_tir           ,
  		                       N_ZAKAZA         ,
  		                       ID_ZAK           ,
  		                       tipovoi_gruz     ,
  		                       nomer_adz        ,
  		                       kol_vo_zakazov   ,
  		                       KOL_VO_PALLETO_MEST,
  		                       MESTO_VIGRUZKI
  		                       )
  		            VALUES   (
  		                       I.id_pok    ,            --ID_TOCIKA_VIGRUZKI  ,
  		                       v_TOCIKA_VIGRUZKI,       --TOCIKA_VIGRUZKI  ,   
  		                       ID_TIR_IN   ,            --id_tir           ,   
  		                       i.n_zakaza , --v_n_zakaza  ,            --N_ZAKAZA         ,   
  		                       I.ID_ZAK    ,            --ID_ZAK           ,   
  		                       v_tip_gruz  ,            --tipovoi_gruz     ,   
  		                       v_n_adz_out ,            --nomer_adz        ,   
  		                       i.quantity  ,            --kol_vo_zakazov   ,   
  		                       v_pm_quant  ,            --KOL_VO_PALLETO_MEST  
  		                       v_MESTO_VIGRUZKI         --MESTO_VIGRUZKI
  		                      );
  	v_n_zakaza:= NULL;
    CK_LOOP:= CK_LOOP+1;  	
  	END LOOP;
  	--ALERT_NOTE('CK_LOOP = '||CK_LOOP);
  END IF;	
EXCEPTION when v_exit then Def_KEY_EXIT; 
	WHEN OTHERS THEN
	 --Dlg.Msg ('*'||Get_Error_Text(text_var), FunTitle||' ошибка');
		Dlg.Msg('*Ошибка в форме <' || :system.current_form || '>' || CHR(10) ||
												error_type	 || '-' ||	 error_code  ||	': ' ||	error_text);
   -- ALERT_NOTE('Внимание ошибка ПРОЦ INSERT_TAB_PARAM MARKER = '||v_marker||' '||SQLERRM );
END;