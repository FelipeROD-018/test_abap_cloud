CLASS zfrh_cl_select DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.

  PRIVATE SECTION.

    TYPES tt_carries TYPE STANDARD TABLE OF /dmo/carrier with EMPTY KEY.
    METHODS get_carries  RETURNING VALUE(rt_carries) TYPE tt_carries.

ENDCLASS.



CLASS zfrh_cl_select IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    out->write( get_carries(  ) ).

  ENDMETHOD.

  METHOD get_carries.

    SELECT * FROM /dmo/carrier
        INTO TABLE @rt_carries.

  ENDMETHOD.

ENDCLASS.
