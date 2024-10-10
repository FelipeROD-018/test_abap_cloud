CLASS zfrh_cl_bank_detail_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.

  PRIVATE SECTION.

    TYPES tt_za_bankdetails TYPE STANDARD TABLE OF zfrh_srvc_bank_details=>tys_a_bank_detail_type WITH EMPTY KEY.
    METHODS get_bank_details_scm RETURNING VALUE(rt_table) TYPE tt_za_bankdetails
                                 RAISING
                                   cx_http_dest_provider_error.

ENDCLASS.



CLASS zfrh_cl_bank_detail_impl IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

     TRY.
         out->write( get_bank_details_scm(  ) ).
       CATCH cx_http_dest_provider_error.
     ENDTRY.

  ENDMETHOD.

  METHOD get_bank_details_scm.


    DATA:
      lt_business_data TYPE TABLE OF zfrh_srvc_bank_details=>tys_a_bank_detail_type,
      lo_http_client   TYPE REF TO if_web_http_client,
      lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request       TYPE REF TO /iwbep/if_cp_request_read_list,
      lo_response      TYPE REF TO /iwbep/if_cp_response_read_lst.

    DATA:
      lo_filter_factory      TYPE REF TO /iwbep/if_cp_filter_factory,
      lo_filter_node_1       TYPE REF TO /iwbep/if_cp_filter_node,
      lo_filter_node_root    TYPE REF TO /iwbep/if_cp_filter_node,
      lt_range_BANK_COUNTRY  TYPE RANGE OF zfrh_srvc_bank_details=>tys_a_bank_detail_type-bank_country.


    TRY.

         DATA: lv_url TYPE string VALUE 'https://sandbox.api.sap.com/'.
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
                        i_destination = cl_http_destination_provider=>create_by_url( lv_url ) ).

        lo_http_client->get_http_request( )->set_header_fields( VALUE #(
             (  name = 'APIKey' value = 'cJqwAHskPyPhHhpB0AurTYylQu7s4ZYq' ) ) ).


        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          EXPORTING
             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      = 'ZFRH_SRVC_BANK_DETAILS'
                                                 proxy_model_version = '0001' )
            io_http_client             = lo_http_client
            iv_relative_service_root   = '/s4hanacloud/sap/opu/odata/sap/API_BANKDETAIL_SRV' ).

        ASSERT lo_http_client IS BOUND.


        " Navigate to the resource and create a request for the read operation
        lo_request = lo_client_proxy->create_resource_for_entity_set( 'A_BANK_DETAIL' )->create_request_for_read( ).

        " Create the filter tree
        lo_filter_factory = lo_request->create_filter_factory( ).
        lt_range_BANK_COUNTRY = VALUE #( ( sign = 'I' option = 'EQ' low = 'DE' high = ' ' ) ).
        lo_filter_node_1  = lo_filter_factory->create_by_range( iv_property_path     = 'BANK_COUNTRY'
                                                                it_range             = lt_range_BANK_COUNTRY ).

        lo_filter_node_root = lo_filter_node_1->and( lo_filter_node_1 ).
        lo_request->set_filter( lo_filter_node_root ).


        lo_request->set_top( 500 )->set_skip( 0 ).

        " Execute the request and retrieve the business data
        lo_response = lo_request->execute( ).
        lo_response->get_business_data( IMPORTING et_business_data = rt_table ).

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        " Handle Exception

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        " Handle Exception
        RAISE SHORTDUMP lx_web_http_client_error.


    ENDTRY.

  ENDMETHOD.

ENDCLASS.
