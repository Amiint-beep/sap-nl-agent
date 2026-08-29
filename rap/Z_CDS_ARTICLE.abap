@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS descriptive pour les articles'
@Metadata.ignorePropagatedAnnotations: true
define view entity Z_CDS_ARTICLE
  as select from zarticle_table
{
  key material_id                            as MaterialId,
      material_desc                          as MaterialDescription,
      material_type                          as MaterialType,
      material_group                         as MaterialGroup,

      base_unit                              as BaseUnit,

      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      stock_qty                              as StockQuantity,

      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      safety_stock                           as SafetyStock,

      storage_location                       as StorageLocation,
      plant                                  as Plant,

      case when stock_qty < safety_stock
           then 'X'
           else ''
      end                                    as BelowSafetyStock
}