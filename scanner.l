%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
%}

%%
"int"               { return INT; }
"float"             { return FLOAT; }
"char"              { return CHAR; }
"if"                { return IF; }
"else"              { return ELSE; }
"for"               { return FOR; }
"while"             { return WHILE; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return IDENTIFIER; }
[0-9]+              { yylval.str = strdup(yytext); return INT_LITERAL; }
[0-9]+\.[0-9]+      { yylval.str = strdup(yytext); return FLOAT_LITERAL; }
\'[^\']\'           { yylval.str = strdup(yytext); return CHAR_LITERAL; }
";"                 { return SEMICOLON; }
"="                 { return EQUAL; }
"+"                 { return PLUS; }
"-"                 { return MINUS; }
"*"                 { return MULTIPLY; }
"/"                 { return DIVIDE; }
"("                 { return LPAREN; }
")"                 { return RPAREN; }
">"                 { return GREATER; }
"<"                 { return LESS; }
"=="                { return EQ; }
">="                { return GREATER_EQUAL; }
"<="                { return LESS_EQUAL; }
"{"                 { return LBRACE; }
"}"                 { return RBRACE; }
[ \t\n]+            { /* ignore whitespace */ }
.                   { printf("Unexpected character: %s\n", yytext); yyerror("Unexpected character"); }
%%

int yywrap(void) {
    return 1;
}
