
insert School (ID, Name, Number, OrgUnitID, ManuallyEntered)
select '71C5B46F-E0E2-4A7E-8AED-4DBAF99F0F09', 'District Office', '3001', '6531EF88-352D-4620-AF5D-CE34C54A9F53', 1
where not exists (select 1 from School where Name = 'District Office')

begin tran
delete T_KeyMath_A where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_GA_EOCT_Math1 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TOPS_R where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_SS_06 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_GFTA2 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_NST where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_Math_06 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TT_SC_BenchmarkMath08 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_BVE where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_Phonics_Benchmark where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_Biology1_HS where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_FCAT_ReadingAndMath where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_CSAP_Growth where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_GA_EOCT_Econ where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TT_SC_BenchmarkSci06 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TOSS_P where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_BASC_2_PRS_A where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_SS_07 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_Key_Math_B where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_GA_EOCT_Math2 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_PLS4thEd where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_OPE where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TCAP where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_DIAL_3 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ELSA where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_Math_07 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TT_SC_BenchmarkELA01 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_CAAP where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_ELA_01 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_SC_Lex4_Benchmark where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_GA_EOCT_USHistory where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TT_SC_BenchmarkSS06 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TOWL_3 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_SS_08 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_PPVT4thEd where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_OWLS where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_Common_Assessment where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_Math_08 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_MCLASSDIBELSNEXT where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_BASC_2_PRS_C where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TT_SC_BenchmarkELA02 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_CREVT where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_InView where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_SB_5 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_ELA_10 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_PLAN where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TT_SC_BenchmarkSci07 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_WLPB_R where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_SS_HS where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_SSI4thEd where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_PAT where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_Math_0K where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TT_SC_BenchmarkELA03 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_DTLA_3 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_ELA_11 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_LLI where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ACT where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_BASC_2_SR_C where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_AP where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_VABS_2_TEA where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_BSAP where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TT_SC_BenchmarkSS07 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_BSAPExit where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_WORD where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_SS_0K where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_CAT5 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_PLSI where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_PhySci_HS where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TT_SC_BenchmarkELA04 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ELT where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_EOCEP where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_ELA_12 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_FL_Alt where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_HSAP where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_SC_Alt where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_MAP where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_BASC_2_SR_A where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TT_SC_BenchmarkSci08 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ITBS where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_MAT7 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_VABS_2_PAR where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_WORD2_E where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_PACT where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_RIPA_P where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_Sci_01 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_PSAT where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TT_SC_BenchmarkELA05 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_EOWPVT where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_PTCS where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_ELA_02 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_SC_SCRA where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_SAT where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TERRANOVA where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TT_SC_BenchmarkSS08 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_WORD_A where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ABAS_III where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_BASC_2_TRS_A where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ROWPVT_SBE where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_Sci_02 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_WISC_4 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TT_SC_BenchmarkELA06 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_EOWPVT_SBE where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_CRCT where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_ELA_03 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_Anderson_2_Custom_ViaTest where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_FAIR where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_STAR_E_Reading where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_FountasPinnellCustom where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_GOLD where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_Battelle_Developmental_Inventory where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_SAM where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_Sci_03 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TT_SC_BenchmarkELA07 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_EOWPVT_SE where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_ELA_04 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_BASC_2_TRS_C where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_WPPSI where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_CO_Aurora_Benchmark where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ISAT where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_STAR_E_Math where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_Woodcock_Johnson_III where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_SPELT where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_Sci_04 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TT_SC_BenchmarkELA08 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_EOWPVTUE_SE where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_ELA_05 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_GA_GHSGT where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_BVMI where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_STAR_E_EarlyLit where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_MI_Access where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TAPS_3 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_Sci_05 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ReadingRecovery where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_IAA where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_FCP where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_ELA_06 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ELPA where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_COGAT where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_BOTMP where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TAPS_UL where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_Sci_06 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_HAPP_R where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_ELA_07 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_CELA where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_DIBELS where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ELDA where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_GWA where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_PSAE where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_Raven where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TARPS where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_Sci_07 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_GOR_A where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_HAPP_S where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_ELA_08 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ScholasticReadingAndMath where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_CASL3_6 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_MEAP where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TEEM where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_Sci_08 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ReadingFirst where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_HELP_E where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_ELA_09 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TABE where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TT_SC_BenchmarkMath01 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_GOR_B where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_Literacy_Assessment where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_GA_EOCT_Algebra where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TOLD_4 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_Sci_HS where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_EXPLORE where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_AEPS where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_KLPA where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_Geometry_HS where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TT_SC_BenchmarkMath02 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ProjectSTAR where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_MONDO where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_KABC_3 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TOLD_P3 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_GA_EOCT_Geometry where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_SS_01 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_COALT where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_LIST where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_MME where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_Math_01 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TT_SC_BenchmarkMath03 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_Literacy_Assessment_Grades_2_6 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_CELLA where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_PASS where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_KABC_4to6 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TONI_3 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_SS_02 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_CASL7_21 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_GA_EOCT_NinthLit where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_LPT_R where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_Math_02 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TT_SC_BenchmarkMath04 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ABI where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_DOMINIE where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_Algebra_EOC where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_DRA where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TOPA where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_SS_03 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_CELF5_8 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_MAVA where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_Math_03 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_KABC_7to18 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_GA_EOCT_AmericanLit where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TT_SC_BenchmarkMath05 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_APAT where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_MCLASSDIBELS6 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_FCAT_Science where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TOPL_2 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_SS_04 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_CELF9_21 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_MEDA where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_Math_04 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TT_SC_BenchmarkMath06 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_APP_R where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_Algebra1_HS where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_GA_EOCT_Biology where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_KBIT_2 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_Galileo where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TOPSA where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_SS_05 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_EVT2 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_MSI where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_FCAT_Writing where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_Math_05 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_PAM where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_TT_SC_BenchmarkMath07 where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_BirthToThree where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_ViaTest_SC_Algebra2_HS where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete T_GA_EOCT_PhysicalSci where SchoolID in (select s.ID from School s where DeletedDate is not null)

Update Teacher set CurrentSchoolID = (select ID from School where Name = 'District Office') where CurrentSchoolID in (select s.ID from School s where DeletedDate is not null)
delete TeacherSchoolHistory where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete ClassRoster where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete StudentTeacherClassRoster where SchoolID in (select s.ID from School s where DeletedDate is not null)
delete School where DeletedDate is not null


-- rollback tran
-- commit tran

--select 'delete '+ name + ' where SchoolID in (select s.ID from School s where DeletedDate is not null)' from sys.objects where type = 'U' and name like 'T[_]%'


--(1 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(2 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(2 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(2 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(1 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(1 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(1 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(1 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(2 row(s) affected)

--(1 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(6 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(1 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(31 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(1 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(3 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(2 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(2 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(3 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(5 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(0 row(s) affected)

--(1032 row(s) affected)

--(1032 row(s) affected)

--(14050 row(s) affected)

--(0 row(s) affected)

--(50 row(s) affected)

























