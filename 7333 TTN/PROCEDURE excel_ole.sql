PROCEDURE excel_ole 
(
  p_nomer_zak_cyc IN varchar2 := null,
   p_ne IN varchar2 := null -- номер экземпляра ??
, p_plan_vr_otgruz IN varchar2 := null --dt_sost ??
, p_plan_t_ts IN varchar2 := null --dt_sost ??
, p_dt_fact IN varchar2 := null
, p_nomer_adz IN varchar2 := null
, P_ID_ZAK IN varchar2 := null, P_ID_ISP IN varchar2 := null, p_inter_swift IN varchar2 := null
, p_TIPOVOI_GRUZ IN varchar2 := null, p_KOL_VO_PALLETO_MEST IN varchar2 := null, p_MASSA IN varchar2 := null
, p_per_doc IN varchar2 := null, p_nomer_plombi IN varchar2 := null, p_massa_mesta IN varchar2 := null
, p_d_to_s IN varchar2 := null, p_voditel IN varchar2 := null, p_type_ts IN varchar2 := null
, p_number_ts IN varchar2 := null, p_n_pu IN varchar2 := null, p_user IN varchar2 := null, p_tsennosti IN varchar2 := null
, p_info_prinyt_zak IN varchar2 := null, P_A41 IN varchar2 := null, P_A45 IN varchar2 := null, P_F40 IN varchar2 := null
, P_ZAO_GK_SEVER IN varchar2 := null, p_kolvo_mesta IN varchar2 := null, p_NAIME_BANK IN varchar2 := null
, p_tlf_zak IN varchar2 := null, p_tlf_pok IN varchar2 := null, p_id_per in varchar2:=null, p_tlf_per in varchar2:=null 
) IS
    hExcel       OLE2.OBJ_TYPE;
    hWorkbooks   OLE2.OBJ_TYPE;
    hWorkbook    OLE2.OBJ_TYPE;
    my_Arglist   OLE2.LIST_TYPE;
    Out_File_Name Varchar2(250);
    Out_File_Dir  Varchar2(250);  
    
    c_c varchar2(10) :=  ' ---- '; 
----------------------------------
--	
----------------------------------> Ed. yurmir *** 19.10.2017 ***
--
-- Declare handles to OLE objects
  application   ole2.OBJ_TYPE;
  workbooks     ole2.OBJ_TYPE;
  workbook      ole2.OBJ_TYPE;
  worksheets    ole2.OBJ_TYPE;
  worksheet     ole2.OBJ_TYPE;
  cell          ole2.OBJ_TYPE;
  args          ole2.OBJ_TYPE;
  Check_file    text_io.file_type;
  no_file       exception;
  PRAGMA exception_INIT (no_file, -302000);
  cell_value    varchar2 (2000);
  
  procedure ins_arg_excel (p_arg in varchar2, p_row in pls_integer, p_col in pls_integer) is
  begin
  	if p_arg is not null and p_row  is not null and p_col is not null then
/*-- PASS VALUE INTO Excel CELL (ROW 371, COL 3)*/
args := ole2.CREATE_ARGLIST;
ole2.ADD_ARG(args, p_row);
ole2.ADD_ARG(args, p_col);
cell := ole2.GET_OBJ_PROPERTY(worksheet,'Cells', args);
ole2.DESTROY_ARGLIST(args);
ole2.SET_PROPERTY(cell, 'Value', p_arg); 
end if;
end;
----------------------------------
begin

  -- ***********************************
  application  := ole2.CREATE_OBJ ('Excel.Application');
--ole2.set_property(application,'Visible','true');
  workbooks    := ole2.GET_OBJ_PROPERTY (application, 'Workbooks');
  args         := ole2.CREATE_ARGLIST;
  ole2.add_arg (args, 'C:\apps\sprut4\template\rapttn4.xls');   --<- yurmir *** 05.10.2017
  workbook     := ole2.GET_OBJ_PROPERTY (workbooks, 'Open', args);
  ole2.destroy_arglist (args);
  worksheets   := ole2.GET_OBJ_PROPERTY (workbook, 'Worksheets');
  worksheet    := ole2.GET_OBJ_PROPERTY (application, 'Activesheet');
  ole2.SET_PROPERTY (worksheet, 'Value', 'TN_FRONTE');
-- ***********************************
 
  OLE2.Set_Property(application, 'Visible', True); 

 /* my_Arglist := OLE2.Create_Arglist;
  OLE2.Add_Arg(my_Arglist, MacroName);*/
--Sheets("TN_FRONTE").Select
--ins_arg_excel (p_nomer_zak_cyc , 3 , 7 );--+10,37--Range("G3").Value = p_nomer_zak_cyc
ins_arg_excel ('Экземпляр №__' , 5 , 1);--Range("A5").Value = p_ne
ins_arg_excel (p_plan_vr_otgruz , 5 , 3 );--?--Range("C5").Value = p_plan_vr_otgruz
ins_arg_excel (p_nomer_adz , 4 , 5 );--Range("E4").Value = p_nomer_adz
ins_arg_excel (P_ID_ZAK , 9 , 1 );--Range("A9").Value = P_ID_ZAK
ins_arg_excel (P_ID_ISP , 9 , 6 );--Range("F9").Value = P_ID_ISP

ins_arg_excel (p_tlf_zak , 12 , 1 );--Range("A14").Value = p_tlf_zak
ins_arg_excel (p_tlf_pok , 12 , 6 );--Range("F14").Value = p_tlf_pok

ins_arg_excel (p_TIPOVOI_GRUZ , 17 , 1 );--Range("A17").Value = p_TIPOVOI_GRUZ
ins_arg_excel ('КОЛИЧЕСТВО МЕСТ-' ||p_KOL_VO_PALLETO_MEST , 19 , 1 );--Range("A19").Value = "КОЛИЧЕСТВО МЕСТ-" & p_KOL_VO_PALLETO_MEST
ins_arg_excel (p_MASSA , 21 , 1 );--ange("A21").Value = p_MASSA
ins_arg_excel (c_c , 23 , 1 );--ange("A23").Value = " ---- "
ins_arg_excel (c_c , 26 , 1 );--Range("A26").Value = " ---- "
--ins_arg_excel (c_c , 33 , 1 );--Range("A32").Value = " ---- "
ins_arg_excel (c_c , 34 , 1 );--Range("A34").Value = " ---- "

ins_arg_excel (p_nomer_zak_cyc , 36 , 1 );--Range("A36").Value = p_nomer_zak_cyc
ins_arg_excel (p_per_doc , 28 , 1 );--Range("A28").Value = p_per_doc
ins_arg_excel (p_tsennosti , 38 , 1 );--Range("A38").Value = p_tsennosti

--
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--> VVVVVV <- yurmir *** 19.10.2017 ***
--
ins_arg_excel (P_ZAO_GK_SEVER , 42 , 1 );--Range("A42").Value = P_ZAO_GK_SEVER
--ins_arg_excel (p_plan_t_ts , 45 , 1 );--Range("A44").Value = p_plan_t_ts
ins_arg_excel (p_plan_t_ts , 47 , 1 );--Range("A46").Value = p_plan_t_ts
ins_arg_excel (p_dt_fact , 47 , 4 );--Range("D46").Value = p_dt_fact
--
--> ^^^^^^ <- yurmir *** 19.10.2017 ***
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--
ins_arg_excel (p_kolvo_mesta , 51 , 4 );--Range("D51").Value = p_kolvo_mesta
ins_arg_excel (p_massa_mesta , 51 , 1 );--Range("A51").Value = p_massa_mesta
ins_arg_excel (p_d_to_s , 45 , 6 );--Range("F45").Value = p_d_to_s
ins_arg_excel (p_nomer_plombi , 49 , 1 );--Range("A49").Value = p_nomer_plombi
--ins_arg_excel (c_c , 56 , 1 );--Range("A56").Value = " ---- "
ins_arg_excel (c_c , 58 , 1 );--Range("A58").Value = " ---- "
ins_arg_excel (c_c , 60 , 1 );--Range("A60").Value = " ---- "
ins_arg_excel (c_c , 62 , 1 );--Range("A62").Value = " ---- "
ins_arg_excel (c_c , 64 , 1 );--Range("A64").Value = " ---- "
ins_arg_excel (c_c , 66 , 1 );--ange("A66").Value = " ---- "
 

--Sheets("TN_RETRO").Select
 -- ole2.SET_PROPERTY (worksheet, 'Value', 'TN_RETRO');
--строка 4=72 --- 68+
--ins_arg_excel (p_info_prinyt_zak ,72/* 4 */, 1 );--Range("A4").Value = p_info_prinyt_zak
ins_arg_excel (p_inter_swift ,78/* 10*/ , 1 );--Range("A10").Value = p_inter_swift
ins_arg_excel (p_voditel , 81 /*13*/ , 1 );--Range("A13").Value = p_voditel
ins_arg_excel (c_c ,76 /* 8 */, 1 );--Range("A8").Value = " ---- "
ins_arg_excel (p_voditel , 76 /* 8 */ , 6 );--Range("F8").Value = p_voditel
ins_arg_excel (p_type_ts , 85 /*17*/ , 1 );--Range("A17").Value = p_type_ts
ins_arg_excel (p_number_ts , 85 /*17*/ , 7 );--Range("G17").Value = p_number_ts
ins_arg_excel (p_n_pu , 68 /*10*/ , 6 );--Range("F10").Value = p_n_pu
ins_arg_excel (p_user , 117 /*49 */, 1 );--Range("A49").Value = p_user
/*ins_arg_excel (c_c , 23 , 1 );--Range("A23").Value = " ---- "
ins_arg_excel (c_c , 23 , 6 );--Range("F23").Value = " ---- "
ins_arg_excel (c_c , 25 , 1 );--Range("A25").Value = " ---- "
ins_arg_excel (c_c , 25 , 6 );--Range("F25").Value = " ---- "
ins_arg_excel (c_c , 29 , 1 );--Range("A29").Value = " ---- "
ins_arg_excel (c_c , 31 , 1 );--Range("A31").Value = " ---- "
ins_arg_excel (c_c , 31 , 6 );--Range("F31").Value = " ---- "
ins_arg_excel (c_c , 35 , 1 );--Range("A35").Value = " ---- "
ins_arg_excel (c_c , 37 , 1 );--Range("A37").Value = " ---- "
ins_arg_excel (c_c , 35 , 6 );--Range("F35").Value = " ---- "
ins_arg_excel (c_c , 37 , 6 );--Range("F37").Value = " ---- "
*/
ins_arg_excel (P_A41 , 109 /*41*/ , 1 );--Range("A41").Value = P_A41
--ins_arg_excel (c_c , 111 /*43*/ , 1 );--Range("A43").Value = " ---- "
ins_arg_excel (P_A45 , 113 /*45 */, 1 );--Range("A45").Value = P_A45
ins_arg_excel (p_NAIME_BANK , 115 /*47*/ , 1 );--Range("A47").Value = p_NAIME_BANK
/*ins_arg_excel (c_c , 41 , 5 );--Range("E41").Value = " ---- "
ins_arg_excel (c_c , 43 , 5 );--Range("E43").Value = " ---- "
ins_arg_excel (c_c , 45 , 5 );--Range("E45").Value = " ---- "
*/
ins_arg_excel (p_voditel , 119 /* 51 */ , 6 );--Range("F51").Value = p_voditel
  alert_note('Продолжить печать других листов ТТН');

	if worksheet is not null then 
  ole2.INVOKE (worksheet, 'Quit');
	end if;
	if worksheet is not null then 
  ole2.INVOKE (workbook, 'Quit');
	end if;
	if cell is not null then 
 -- client_ole2.INVOKE (workbook, 'CLOSE');
-- Release the client_ole2 object handles
  ole2.release_obj (cell);
	end if;
	if worksheet is not null then 
  ole2.release_obj (worksheet);
	end if;
	if worksheetS is not null then 
  ole2.release_obj (worksheets);
	end if;
	if workbook is not null then 
  ole2.release_obj (workbook);
	end if;
	if workbooks is not null then 
  ole2.release_obj (workbooks);
	end if;

	if application is not null then 
  ole2.invoke (application, 'Quit');
  ole2.release_obj (application);
	end if;

exception when others then
alert_note(sqlerrm);	
END;
