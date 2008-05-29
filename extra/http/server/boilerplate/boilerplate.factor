! Copyright (c) 2008 Slava Pestov
! See http://factorcode.org/license.txt for BSD license.
USING: accessors kernel namespaces http.server html.templates
locals ;
IN: http.server.boilerplate

TUPLE: boilerplate < filter-responder template ;

: <boilerplate> f boilerplate boa ;

M:: boilerplate call-responder* ( path responder -- )
    path responder call-next-method
    dup content-type>> "text/html" = [
        clone [| body |
            [ body responder template>> with-boilerplate ]
        ] change-body
    ] when ;
