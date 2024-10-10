CLASS zfrh_rap_class_businessp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

         INTERFACES if_oo_adt_classrun .

         TYPES t_businessp_range TYPE RANGE OF zfrh_srvc_api_hub_v2=>tys_a_business_partner_type-business_partner.
         TYPES t_businessp_data TYPE TABLE of zfrh_srvc_api_hub_v2=>tys_a_business_partner_type.

         METHODS get_businessp
            IMPORTING
              it_filter TYPE if_rap_query_filter=>tt_name_range_pairs OPTIONAL
              top       TYPE i OPTIONAL
              ski       TYPE i OPTIONAL
            EXPORTING
              et_businessp_data TYPE t_businessp_data
            RAISING
              /iwbep/cx_cp_remote
              /iwbep/cx_gateway
              cx_web_http_client_error
              cx_http_dest_provider_error.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zfrh_rap_class_businessp IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.


    DATA lt_filter_conditions TYPE if_rap_query_filter=>tt_name_range_pairs.
    DATA lt_businessp_data  TYPE TABLE OF zfrh_srvc_api_hub_v2=>tys_a_business_partner_type.

    TRY.

      get_businessp(
        EXPORTING
            it_filter  = lt_filter_conditions
            top        = 2
            ski        = 1
        IMPORTING
          et_businessp_data = lt_businessp_data ).

     out->write( 'Salida correcta: ' ).
     out->write( lt_businessp_data ).
     CATCH cx_root INTO DATA(lt_exception).
     out->write( cl_message_helper=>get_latest_t100_exception( lt_exception )->if_message~get_longtext( ) ).

    ENDTRY.

  ENDMETHOD.

  METHOD get_businessp.


    DATA:
      ls_entity_key    TYPE zfrh_srvc_api_hub_v2=>tys_a_business_partner_type,
      ls_business_data TYPE zfrh_srvc_api_hub_v2=>tys_a_business_partner_type,
      lo_resource      TYPE REF TO /iwbep/if_cp_resource_entity,
      lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request       TYPE REF TO /iwbep/if_cp_request_read,
      lo_response      TYPE REF TO /iwbep/if_cp_response_read.

    TRY.

       "create http destination by url; API endpoint for API sandbox
*        DATA(lo_http_destination) =
*             cl_http_destination_provider=>create_by_url( 'https://vhcals4hci.dummy.nodomain:44300' ).
        DATA(lo_http_destination) =
             cl_http_destination_provider=>create_by_url( 'https://sandbox.api.sap.com/s4hanacloud' ).

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ) .

        DATA(lo_web_http_request) = lo_http_client->get_http_request( ).

        lo_web_http_request->set_header_fields( VALUE #(
        (  name = 'APIKey' value = 'cJqwAHskPyPhHhpB0AurTYylQu7s4ZYq' )
        (  name = 'DataServiceVersion' value = '2.0' )
        (  name = 'Accept' value = 'application/json' )
         ) ).

        "Config proxy
        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          EXPORTING
             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      = 'ZFRH_SRVC_API_HUB_V2'
                                                 proxy_model_version = '0001' )
            io_http_client             = lo_http_client
            iv_relative_service_root   = '/sap/opu/odata/sap/API_BUSINESS_PARTNER' ).


        ASSERT lo_http_client IS BOUND.


        " Set entity key
        ls_entity_key = VALUE #(
                  business_partner  = '1000001' ).

        " Navigate to the resource
        lo_resource = lo_client_proxy->create_resource_for_entity_set( 'A_BUSINESS_PARTNER' )->navigate_with_key( ls_entity_key ).

        " Execute the request and retrieve the business data
        lo_response = lo_resource->create_request_for_read( )->execute( ).
        lo_response->get_business_data( IMPORTING es_business_data = ls_business_data ).

        APPEND ls_business_data to et_businessp_data.

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
