%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);
extern FILE *yyin;
%}

%union {
    char *str;
}

%token <str> IDENTIFIER
%token INT FLOAT CHAR
%token <str> INT_LITERAL FLOAT_LITERAL CHAR_LITERAL
%token SEMICOLON EQUAL
%token PLUS MINUS MULTIPLY DIVIDE
%token IF ELSE FOR WHILE
%token LPAREN RPAREN
%token GREATER LESS GREATER_EQUAL LESS_EQUAL
%token LBRACE RBRACE
%token EQ  

%type <str> type declaration variable_declaration assignment expression statement condition statements loop for_initialization for_update declarations

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%right EQUAL
%left OR
%left AND
%left EQ GREATER LESS GREATER_EQUAL LESS_EQUAL
%left PLUS MINUS
%left MULTIPLY DIVIDE
%right NOT
%right UMINUS

%start program

%%
program:
    declarations { printf("Parsed program\n"); }
    ;

declarations:
    declaration declarations { printf("Parsed declarations\n"); $$ = strdup(""); }
    | /* empty */ { $$ = strdup(""); }
    ;

declaration:
    variable_declaration { printf("Parsed declaration: variable_declaration\n"); $$ = strdup(""); }
    | assignment { printf("Parsed declaration: assignment\n"); $$ = strdup(""); }
    | condition { printf("Parsed declaration: condition\n"); $$ = strdup(""); }
    | loop { printf("Parsed declaration: loop\n"); $$ = strdup(""); }
    ;

variable_declaration:
    type IDENTIFIER SEMICOLON {
        printf("Parsed variable declaration: %s %s;\n", $1, $2);
        $$ = strdup("var_decl");
    }
    ;

assignment:
    IDENTIFIER EQUAL expression SEMICOLON {
        printf("Parsed assignment: %s = %s;\n", $1, $3);
        char* result = malloc(strlen($1) + strlen($3) + 4);
        sprintf(result, "%s = %s;", $1, $3);
        $$ = result;
    }
    ;

condition:
    IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE {
        printf("Parsed conditional: if (%s) then [%s]\n", $3, $5);
        char* result = malloc(strlen("if (") + strlen($3) + strlen(") ") + strlen($5) + 6);
        sprintf(result, "if (%s) {\n%s\n}", $3, $5);
        $$ = result;
    }
    | IF LPAREN expression RPAREN statement ELSE statement {
        printf("Parsed conditional: if (%s) then [%s] else [%s]\n", $3, $5, $7);
        char* result = malloc(strlen("if (") + strlen($3) + strlen(") ") + strlen($5) + strlen($7) + 14);
        sprintf(result, "if (%s) {\n%s\n} else {\n%s\n}", $3, $5, $7);
        $$ = result;
    }
    ;

loop:
    FOR LPAREN for_initialization SEMICOLON expression SEMICOLON for_update RPAREN statement {
        printf("Parsed for loop: for (%s; %s; %s) [%s]\n", $3, $5, $7, $9);
        char* result = malloc(strlen("for (") + strlen($3) + strlen("; ") + strlen($5) + strlen("; ") + strlen($7) + strlen(") ") + strlen($9) + 6);
        sprintf(result, "for (%s; %s; %s) {\n%s\n}", $3, $5, $7, $9);
        $$ = result;
    }
    | WHILE LPAREN expression RPAREN statement {
        printf("Parsed while loop: while (%s) [%s]\n", $3, $5);
        char* result = malloc(strlen("while (") + strlen($3) + strlen(") ") + strlen($5) + 6);
        sprintf(result, "while (%s) {\n%s\n}", $3, $5);
        $$ = result;
    }
    ;

for_initialization:
    assignment { printf("Parsed for initialization: %s\n", $1); $$ = $1; }
    | /* empty */ { $$ = strdup(""); }
    ;

for_update:
    assignment { printf("Parsed for update: %s\n", $1); $$ = $1; }
    | /* empty */ { $$ = strdup(""); }
    ;

statement:
    LBRACE statements RBRACE {
        printf("Parsed statement: block\n");
        $$ = $2;
    }
    | variable_declaration
    | assignment
    | condition
    | loop
    ;

statements:
    statement statements {
        char *result = malloc(strlen($1) + strlen($2) + 1);
        strcpy(result, $1);
        strcat(result, $2);
        $$ = result;
        printf("Parsed statements\n");
    }
    | /* empty */ {
        $$ = strdup("");
        printf("Parsed empty statements\n");
    }
    ;

expression:
    IDENTIFIER { printf("Parsed identifier: %s\n", $1); $$ = strdup($1); }
    | INT_LITERAL { printf("Parsed int literal: %s\n", $1); $$ = strdup($1); }
    | FLOAT_LITERAL { printf("Parsed float literal: %s\n", $1); $$ = strdup($1); }
    | CHAR_LITERAL { printf("Parsed char literal: %s\n", $1); $$ = strdup($1); }
    | expression PLUS expression {
        printf("Parsed expression: %s + %s\n", $1, $3);
        char* result = malloc(strlen($1) + strlen($3) + 4);
        sprintf(result, "%s + %s", $1, $3);
        $$ = result;
    }
    | expression MINUS expression {
        printf("Parsed expression: %s - %s\n", $1, $3);
        char* result = malloc(strlen($1) + strlen($3) + 4);
        sprintf(result, "%s - %s", $1, $3);
        $$ = result;
    }
    | expression MULTIPLY expression {
        printf("Parsed expression: %s * %s\n", $1, $3);
        char* result = malloc(strlen($1) + strlen($3) + 4);
        sprintf(result, "%s * %s", $1, $3);
        $$ = result;
    }
    | expression DIVIDE expression {
        printf("Parsed expression: %s / %s\n", $1, $3);
        char* result = malloc(strlen($1) + strlen($3) + 4);
        sprintf(result, "%s / %s", $1, $3);
        $$ = result;
    }
    | expression GREATER expression {
        printf("Parsed expression: %s > %s\n", $1, $3);
        char *result = malloc(strlen($1) + strlen($3) + 4);
        sprintf(result, "%s > %s", $1, $3);
        $$ = result;
    }
    | expression LESS expression {
        printf("Parsed expression: %s < %s\n", $1, $3);
        char *result = malloc(strlen($1) + strlen($3) + 4);
        sprintf(result, "%s < %s", $1, $3);
        $$ = result;
    }
    | expression GREATER_EQUAL expression {
        printf("Parsed expression: %s >= %s\n", $1, $3);
        char *result = malloc(strlen($1) + strlen($3) + 5);
        sprintf(result, "%s >= %s", $1, $3);
        $$ = result;
    }
    | expression LESS_EQUAL expression {
        printf("Parsed expression: %s <= %s\n", $1, $3);
        char *result = malloc(strlen($1) + strlen($3) + 5);
        sprintf(result, "%s <= %s", $1, $3);
        $$ = result;
    }
    | '-' expression %prec UMINUS {
        printf("Parsed expression: -%s\n", $2);
        char *result = malloc(strlen($2) + 2);
        sprintf(result, "-%s", $2);
        $$ = result;
    }
    | expression EQ expression {
        printf("Parsed expression: %s == %s\n", $1, $3);
        char *result = malloc(strlen($1) + strlen($3) + 5);
        sprintf(result, "%s == %s", $1, $3);
        $$ = result;
    }
    | LPAREN expression RPAREN {
        printf("Parsed expression: (%s)\n", $2);
        $$ = $2;
    }
    ;

type:
    INT { $$ = strdup("int"); }
    | FLOAT { $$ = strdup("float"); }
    | CHAR { $$ = strdup("char"); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror(argv[1]);
            return 1;
        }
        yyin = file;
    }
    yyparse();
    return 0;
}
