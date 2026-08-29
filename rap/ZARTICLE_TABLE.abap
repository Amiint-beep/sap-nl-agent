@EndUserText.label : 'Article master data (MM demo)'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zarticle_table {

  key client       : abap.clnt not null;
  key material_id  : abap.char(18) not null;
  material_desc    : abap.char(40);
  material_type    : abap.char(4);
  material_group   : abap.char(9);
  base_unit        : abap.unit(3);
  @Semantics.quantity.unitOfMeasure : 'zarticle_table.base_unit'
  stock_qty        : abap.quan(13,3);
  @Semantics.quantity.unitOfMeasure : 'zarticle_table.base_unit'
  safety_stock     : abap.quan(13,3);
  storage_location : abap.char(4);
  plant            : abap.char(4);

}