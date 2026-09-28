-- Step 1: DW - Create star schema tables
.read Projects/2_DW_Mart_Build/01_create_tables_dw.sql

-- Step 2: DW - Load data from CSV files into tables
.read Projects/2_DW_Mart_Build/02_load_schema_dw.sql

-- Step 3: Mart - Create flat mart table
.read Projects/2_DW_Mart_Build/03_create_flat_mart.sql

-- Step 4: Mart - Create skills demand mart
.read Projects/2_DW_Mart_Build/04_create_skills_mart.sql

-- Step 5: Mart - Create priority roles mart
.read Projects/2_DW_Mart_Build/05_create_priority_mart.sql

-- Step 6: Mart - Update priority roles mart
.read Projects/2_DW_Mart_Build/06_update_priority_mart.sql

-- Step 7: Mart - Create company prospecting mart (dimensional mart)
.read Projects/2_DW_Mart_Build/07_create_company_mart.sql
