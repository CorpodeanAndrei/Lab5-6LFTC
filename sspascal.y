%{
	int yylex();
%}
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define YYDEBUG 1

#define TIP_INT 1
#define TIP_REAL 2
#define TIP_CAR 3
int yylex(void);
int yyerror(char *s);


double stiva[20];
int sp;

void push(double x)
{ stiva[sp++]=x; }

double pop()
{ return stiva[--sp]; }

%}

%union {
  	int l_val;
	char *p_val;
}

%token START
%token FOR
%token WRITE
%token OF
%token CONST
%token DO
%token ELSE
%token STOP
%token IF
%token PRINT
%token TO
%token PROGRAM
%token READ
%token FROM
%token THEN
%token VAR
%token WHILE

%token ID
%token <p_val> CONST_INT
%token <p_val> CONST_REAL
%token <p_val> CONST_CAR
%token CONST_SIR

%token CHAR
%token INTEGER
%token REAL

%token NE
%token LE
%token GE
%token EF
%token ET

%left '+' '-'
%left DIV MOD '*' '/'
%left OR
%left AND
%left NOT

%type <l_val> expr_stat factor_stat constanta
%%
prog_sursa:	decl_list ':' cmpdstmt ';'
		;
decl_list: declaration
		|	declaration ',' decl_list
		;
declaration: ID type ';'
		;
type1:	INTEGER
		| REAL
		| CHAR
		;
type:	type1
		| decl_list
		;
assignstmt:	ID '=' expression
		;
expression:	expression '+' term
		|	term
		;
term:	term '*' factor
		|	factor
		;
factor:	'(' expression ')'
		|	ID
		;
forstmt:	'for' '(' ID '=' INTEGER ':' ID '<' ID ':' ID '=' ID expresie INTEGER ')' stmt ';'
		;
sect_const:	/* empty */
		| CONST lista_const
		;
lista_const:	decl_const
		| lista_const decl_const
		;
sect_var:	/* empty */
		| VAR lista_var
		;
lista_var:	decl_var
		| lista_var decl_var
		;
decl_const:	ID '=' {sp=0;} expr_stat ';'	{
		printf("*** %d %g ***\n", $4, pop());
					}
		;
decl_var:	lista_id ':' type ';'
		;
lista_id:	ID
		| lista_id ',' ID
		;

expr_stat:	factor_stat
		| expr_stat '+' expr_stat	{
			if($1==TIP_REAL || $3==TIP_REAL) $$=TIP_REAL;
			else if($1==TIP_CAR) $$=TIP_CAR;
				else $$=TIP_INT;
			push(pop()+pop());
						}
		| expr_stat '-' expr_stat	{
			if($1==TIP_REAL || $3==TIP_REAL) $$=TIP_REAL;
			else if($1==TIP_CAR) $$=TIP_CAR;
				else $$=TIP_INT;
			push(-pop()+pop());
						}
		| expr_stat '*' expr_stat	{
			if($1==TIP_REAL || $3==TIP_REAL) $$=TIP_REAL;
			else if($1==TIP_CAR) $$=TIP_CAR;
				else $$=TIP_INT;
			push(pop()*pop());
						}
		| expr_stat '/' expr_stat	
		| expr_stat DIV expr_stat
		| expr_stat MOD expr_stat
		;
factor_stat:	ID		{}
		| constanta
		| '(' expr_stat ')'	{$$ = $2;}
		;
constanta:	CONST_INT	{
			$$ = TIP_INT;
			push(atof($1));
				}
		| CONST_REAL	{
			$$ = TIP_REAL;
			push(atof($1));
				}
		| CONST_CAR	{
			$$ = TIP_CAR;
			push((double)$1[0]);
				}
		;
cmpdstmt:	START stmlist STOP
		;
stmlist:	stmt
		| stmlist ';' stmlist
		;
stmt:		/* empty */
		| ifstmt
		| whilestmt
		| cmpdstmt
		| readstmt
		| printstmt
		;
expresion:	factor
		| expression '+' expression
		| expression '-' expression
		| expression '*' expression
		| expression '/' expression
		| expression DIV expression
		| expression MOD expression
		;
expressionlist:	expression
		| expressionlist ',' expression
		;
ifstmt:	IF condition THEN stmt elsestmt
		;
elsestmt:	/* empty */
		ELSE stmt
		;
condition:	expr_logica
		| expression operators expression
		;
expr_logica:	factor_logic
		| expr_logica AND expr_logica
		| expr_logica OR expr_logica
		;
factor_logic:	'(' condition ')'
		| NOT factor_logic
		;
operators:		'='
		| '<'
		| '>'
		| '<='
		| '>='
		| NE
		| LE
		| GE
		| EF
		| ET
		;
whilestmt:	WHILE condition DO stmt
		;
printstmt:	PRINT '(' elem_list ')'
		;
elem_list:	element
		| elem_list ',' element
		;
element:	expression
		| decl_list
		;
readstmt:	READ '(' decl_list ')'
		;

%%

yyerror(char *s)
{
  printf("%s\n", s);
  return 0;
}

extern FILE *yyin;

main(int argc, char **argv)
{
  if(argc>1) yyin = fopen(argv[1], "r");
  if((argc>2)&&(!strcmp(argv[2],"-d"))) yydebug = 1;
  if(!yyparse()) fprintf(stderr,"\tO.K.\n");
}

