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

    out->write( 'Inicio de prueba' ).

    TRY.
        "create http destination by url; API endpoint for API sandbox
        DATA(lo_http_destination) =
             cl_http_destination_provider=>create_by_url( 'https://sandbox.api.sap.com/s4hanacloud/sap/opu/odata/sap/API_BUSINESS_PARTNER/A_BusinessPartner(''1000001'')' ).

        "create HTTP client by destination
        DATA(lo_web_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ) .

        "adding headers with API Key for API Sandbox
        DATA(lo_web_http_request) = lo_web_http_client->get_http_request( ).

        lo_web_http_request->set_header_fields( VALUE #(
        (  name = 'APIKey' value = 'cJqwAHskPyPhHhpB0AurTYylQu7s4ZYq' )
        (  name = 'DataServiceVersion' value = '2.0' )
        (  name = 'Accept' value = 'application/json' )
         ) ).

        "set request method and execute request
        DATA(lo_web_http_response) = lo_web_http_client->execute( if_web_http_client=>get ).
        DATA(lv_response) = lo_web_http_response->get_text( ).

      CATCH cx_http_dest_provider_error cx_web_http_client_error cx_web_message_error.
        "error handling
    ENDTRY.

    out->write( |response:  { lv_response }| ).

  ENDMETHOD.

ENDCLASS.
