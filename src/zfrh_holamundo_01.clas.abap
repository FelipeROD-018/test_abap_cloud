CLASS zfrh_holamundo_01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zfrh_holamundo_01 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    out->write( 'Test 01' ).

  ENDMETHOD.

ENDCLASS.
