
<<<<<<< HEAD
set modulesdirectory="E:\Sites\Enrich\Excent Enrich DC5 CO Poudre\Setup\7.26.4.3419\Product\DbScripts"
set connection="server=.;uid=CO_UPB_User;pwd=vc3go!!;database=Enrich_COUPB"
=======
set modulesdirectory="E:\Inetpub\Sites\Enrich_DCB7_CODYC\Setup\7.26.4.3419\Product\DbScripts"
set connection=server=10.0.1.30;uid=DCB7_CO_DYC;pwd=vc3go!!;database=Enrich_DCB7_CO_DYC
>>>>>>> 12fcab530dfd2754dee3d84c5fa962e8e39e1ad5
ExecuteTask\ExecuteTask.exe upgradedb modulesdirectory=%modulesdirectory% connectionstring=%connection% ignoremissingmodules=true


