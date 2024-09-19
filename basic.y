%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char name[100];
    int value;
} Variable;

Variable varTable[100];
int varCount = 0;

int getVarValue(char* name);
void setVarValue(char* name, int value);

%}

%union {
    int ival;
    char* sval;
}

%token <ival> INTEGER
%token <sval> VARIABLE
%token PRINT IF THEN ENDIF FOR TO DO NEXT WHILE ENDWHILE GOTO LABEL LET END

%%

program:
    statement_list
    ;

statement_list:
    statement '\n'
  | statement '\n' statement_list
  ;

statement:
    assignment_statement
  | print_statement
  | if_statement
  | for_statement
  | while_statement
  | goto_statement
  | label
  | END
  ;

assignment_statement:
    LET VARIABLE '=' expression
    {
        setVarValue($2, $4);
    }
    ;

print_statement:
    PRINT expression
    {
        printf("%d\n", $2);
    }
    ;

if_statement:
    IF condition THEN statement_list ENDIF
    ;

for_statement:
    FOR VARIABLE '=' expression TO expression DO statement_list NEXT
    ;

while_statement:
    WHILE condition DO statement_list ENDWHILE
    ;

goto_statement:
    GOTO LABEL
    ;

label:
    VARIABLE ':'
    ;

condition:
    expression '<' expression
  | expression '>' expression
  | expression '=' expression
  ;

expression:
    term
  | term '+' term { $$ = $1 + $3; }
  | term '-' term { $$ = $1 - $3; }
  ;

term:
    factor
  | factor '*' factor { $$ = $1 * $3; }
  | factor '/' factor { $$ = $1 / $3; }
  ;

factor:
    VARIABLE { $$ = getVarValue($1); }
  | INTEGER { $$ = $1; }
  | '(' expression ')' { $$ = $2; }
  ;

%%

int main(void) {
    printf("BASIC Interpreter\n");
    return yyparse();
}

void yyerror(const char* s) {
    printf("Error: %s\n", s);
}
