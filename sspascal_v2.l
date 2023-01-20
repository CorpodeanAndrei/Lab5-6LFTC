%option noyywrap
%{
#include "sspascal.tab.h"
%}

%option noyywrap
%option caseless
%option yylineno
%option lex-compat

LITERA		[A-Za-z_]
CIFRA_ZEC	[0-9]
IDENTIFICATOR	{LITERA}({LITERA}|{CIFRA_ZEC})*
NR_BAZA10	{CIFRA_ZEC}+
EXPON		(E|e)("+"?|"-"){CIFRA_ZEC}{1,2}
NR_REAL		{NR_BAZA10}"."{NR_BAZA10}{EXPON}?
DELIMIT_1	[;.,:]
OPERATOR_1	[+*/()<>=]|"-"|"["|"]"
COMENT		"{"[^}]*"}"
SIR_CAR		["][^\n"]*["]
CARACTER	"'"[^\n]"'"

%%

[ \t\n]
{COMENT}

const	{return CONST;}
do		{return DO;}
else	{return ELSE;}
if		{return IF;}
program	{return PROGRAM;}
then	{return THEN;}
var		{return VAR;}
while	{return WHILE;}
for		{return FOR;}
start	{return START;}
write	{return WRITE;}
of		{return OF;}
stop	{return STOP;}
print	{return PRINT;}
to		{return TO;}
read	{return READ;}
from	{return FROM;}




char		{return CHAR;}
integer		{return INTEGER;}
real		{return REAL;}

"<>"		{return NE;}
"<="		{return LE;}
">="		{return GE;}
"=="		{return ET;}
"!="		{return EF;}
div		{return DIV;}
mod		{return MOD;}
or		{return OR;}
and		{return AND;}
not		{return NOT;}

{IDENTIFICATOR}	{return ID;}
{NR_BAZA10}	{
	yylval.p_val = yytext;
	return CONST_INT;
		}
{NR_REAL}	{
	yylval.p_val = yytext;
	return CONST_REAL;
		}
{CARACTER}	{
	yylval.p_val = yytext;
	return CONST_CAR;
		}
{SIR_CAR}	{return CONST_SIR;}

{DELIMIT_1}	{return yytext[0];}
{OPERATOR_1}	{return yytext[0];}

%%

