%{
#include "Parser.h"
#include <stdio.h>
#include <string.h>
#define YYSTYPE_IS_DECLARED 1
%}

%%
[0-9]+          { yylval.ival = atoi(yytext); return INTEGER; }
"LET"           { return LET; }
"PRINT"         { return PRINT; }
"IF"            { return IF; }
"THEN"          { return THEN; }
"ENDIF"         { return ENDIF; }
"FOR"           { return FOR; }
"TO"            { return TO; }
"DO"            { return DO; }
"NEXT"          { return NEXT; }
"WHILE"         { return WHILE; }
"ENDWHILE"      { return ENDWHILE; }
"GOTO"          { return GOTO; }
"END"           { return END; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return VARIABLE; }
[ \t]+          { /* Ignorar espaços e tabulações */ }
\n              { return '\n'; }
.               { return yytext[0]; }
%%

int yywrap() {
    return 1;
}
