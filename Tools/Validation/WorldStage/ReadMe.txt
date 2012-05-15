To setup WorldStage on your machine:

1. Create WorldStage folder on your machine.

2. Unzip WorldStageDeploy.zip

3. Open SQL management studio.

4. Create the Tool's SQL Userid by running the following script:  create_user.sql

5. Execute ELINK_Master_Create Script.sql. Make sure that you rename ELINK_MASTER database with state and district id (example: ELINK_FLLE).

6. Execute ESTAGE_Master_Create Script.sql. Make sure that you rename ESTAGE_MASTER database with state and district id (example: ESTAGE_FLLE). State and district IDs must be the same for both databases.

7. You can also restore two databases included in ZIP file. The naming convention is the same as above: ELINK_STATEIDDISTRICTID and ESTAGE_STATEIDDISTRICTID.

8. Open stage.config and change owner id to your state and district ID used to name your databases.

9. Copy your import files into a directory .\ImportFiles  (. means current directory where worldstage tool is)

10. Register all your import files into the table dlinkfile in ELINK_STATEDISTRICTID database by modifying and running register_import_files.sql

11. Launch WorldStage.exe application.

Note: WorldStage.exe requires FoxPro runtime components. The easiest way to install them is to run EnrichStage's setup.exe.