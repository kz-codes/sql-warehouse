# SQL WareHouse

## Data Architecture

![Data Architecture](./images/sources.excalidraw.svg)

## Entity relations

![Entity Relations](./images/entity_relations.png)

### TODOS

- [x] init Database

- [x] build Bronze Layer
  - [x] Analyse Source systems
  - [x] code data ingestion
  - [x] validate data -> completeness and schema checks

- [x] Build Silver Layer
  - [x] Explore Data
  - [x] code data cleansing
    - [x] SCD2 => get only latest data
    - [x] unwanted spaces in nvarchar datatypes
    - [x] Low cardinality columns are expanded
  - [x] validation -> correctness checks

- [ ] Build Gold Layer
  - [ ] explore Business Objects
  - [ ] code data integration
  - [ ] validation -> data integration checks
