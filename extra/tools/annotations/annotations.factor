! Copyright (C) 2005, 2007 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel words parser io inspector quotations sequences
prettyprint continuations effects definitions ;
IN: tools.annotations

<PRIVATE

: check-compound ( word -- word )
    compound? [
        "Annotations can only be used with compound words" throw
    ] unless ;

: reset ( word -- )
    dup check-compound
    dup "unannotated-def" word-prop define-compound ;

: annotate ( word quot -- )
    over check-compound
    [
        >r dup word-def r> call define-compound
    ] with-compilation-unit ; inline

: entering ( str -- )
    "/-- Entering: " write dup .
    stack-effect [
        >r datastack r> effect-in length tail* stack.
    ] [
        .s
    ] if* "\\--" print flush ;

: leaving ( str -- )
    "/-- Leaving: " write dup .
    stack-effect [
        >r datastack r> effect-out length tail* stack.
    ] [
        .s
    ] if* "\\--" print flush ;

: (watch) ( word def -- def )
    over [ entering ] curry
    rot [ leaving ] curry
    swapd 3append ;

PRIVATE>

: watch ( word -- )
    dup [ (watch) ] annotate ;

: breakpoint ( word -- )
    [ \ break add* ] annotate ;

: breakpoint-if ( word quot -- )
    [ [ [ break ] when ] rot 3append ] curry annotate ;
