To setup WorldStage on your machine:

1. Create WorldStage folder on your machine.
2. Unzip WorldStageDeploy.zip
3. Open SQL management studio.
4. Execute ELINK_Master_Create Script.sql. Make sure that you rename ELINK_MASTER database with state and district id (example: ELINK_FLLE).
5. Execute ESTAGE_Master_Create Script.sql. Make sure that you rename ESTAGE_MASTER database with state and district id (example: ESTAGE_FLLE). State and district IDs must be the same for both databases.
6. You can also restore two databases included in ZIP file. The naming convention is the same as above: ELINK_STATEIDDISTRICTID and ESTAGE_STATEIDDISTRICTID.
6. Open stage.config and change owner id to your state and district ID used to name your databases.
7. Launch WorldStage.exe application.

Note: WorldStage.exe requires FoxPro runtime components. The easiest way to install them is to run EnrichStage's setup.exe.