# SQL WareHouse

Look at [Notes](./notes.pdf) for Notes taken along

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

- [x] Build Gold Layer
  - [x] explore Business Objects
  - [x] code data integration
  - [x] validation -> data integration checks
