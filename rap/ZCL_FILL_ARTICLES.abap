CLASS zcl_fill_articles DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
  TYPES tt_articles TYPE STANDARD TABLE OF zarticle_table WITH EMPTY KEY. "la déclaration du type à l'intérieur de la classe en private
                                                                          " et VALUE un peu plus bas a besoin du type car il est un constructeur
ENDCLASS.

CLASS zcl_fill_articles IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    " on vide la table au préalable
    DELETE FROM zarticle_table.

       DATA(lt_articles) = VALUE tt_articles(
      ( material_id = '000000000000001001' material_desc = 'Fil de coton peigne Ne 30'
        material_type = 'ROH' material_group = 'FIL01' base_unit = 'KG'
        stock_qty = '8400.000'  safety_stock = '3000.000'
        storage_location = 'MP01' plant = '1000' )
      ( material_id = '000000000000001002' material_desc = 'Fil polyester texture 150D'
        material_type = 'ROH' material_group = 'FIL01' base_unit = 'KG'
        stock_qty = '1250.000'  safety_stock = '2500.000'
        storage_location = 'MP01' plant = '1000' )
      ( material_id = '000000000000001003' material_desc = 'Toile denim 12 oz brut'
        material_type = 'ROH' material_group = 'TIS01' base_unit = 'M'
        stock_qty = '15600.000' safety_stock = '5000.000'
        storage_location = 'MP01' plant = '1000' )
      ( material_id = '000000000000001004' material_desc = 'Colorant indigo synthetique'
        material_type = 'ROH' material_group = 'CHM01' base_unit = 'KG'
        stock_qty = '320.000'   safety_stock = '600.000'
        storage_location = 'MP02' plant = '1000' )
      ( material_id = '000000000000002001' material_desc = 'Etiquette tissee marque'
        material_type = 'VERP' material_group = 'EMB01' base_unit = 'ST'
        stock_qty = '240000.000' safety_stock = '80000.000'
        storage_location = 'EM01' plant = '1000' )
      ( material_id = '000000000000002002' material_desc = 'Sachet polybag 30x40'
        material_type = 'VERP' material_group = 'EMB01' base_unit = 'ST'
        stock_qty = '19000.000' safety_stock = '45000.000'
        storage_location = 'EM01' plant = '1000' )
      ( material_id = '000000000000003001' material_desc = 'T-shirt col rond blanc M'
        material_type = 'FERT' material_group = 'PF001' base_unit = 'ST'
        stock_qty = '18700.000' safety_stock = '6000.000'
        storage_location = 'PF01' plant = '1000' )
      ( material_id = '000000000000003002' material_desc = 'Jean coupe droite brut 32'
        material_type = 'FERT' material_group = 'PF002' base_unit = 'ST'
        stock_qty = '2900.000'  safety_stock = '7500.000'
        storage_location = 'PF01' plant = '1000' )
      ( material_id = '000000000000003003' material_desc = 'Sweat capuche gris chine L'
        material_type = 'FERT' material_group = 'PF002' base_unit = 'ST'
        stock_qty = '11400.000' safety_stock = '4000.000'
        storage_location = 'PF01' plant = '2000' )
      ( material_id = '000000000000004001' material_desc = 'Aiguille machine surjeteuse'
        material_type = 'HIBE' material_group = 'CONS1' base_unit = 'ST'
        stock_qty = '450.000'   safety_stock = '1200.000'
        storage_location = 'DIV1' plant = '2000' )
      ( material_id = '000000000000004002' material_desc = 'Rouleau papier de coupe'
        material_type = 'HIBE' material_group = 'CONS1' base_unit = 'ROL'
        stock_qty = '96.000'    safety_stock = '40.000'
        storage_location = 'DIV1' plant = '1000' )
    ).

    INSERT zarticle_table FROM TABLE @lt_articles.

    out->write( |{ sy-dbcnt } articles inseres.| ).

    SELECT * FROM zarticle_table INTO TABLE @DATA(lt_check).
    out->write( lt_check ).

  ENDMETHOD.

ENDCLASS.