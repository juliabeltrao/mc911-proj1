%{
#include "parser.h"
%}

%option noyywrap

%%

" "					{printf("%s\n", yytext);return ' ';}
"\\"				{printf("%s\n", yytext);return '\\';}
"["					{printf("%s\n", yytext);return '[';}
"]"					{printf("%s\n", yytext);return ']';}
"{"					{printf("%s\n", yytext);return '{';}
"}"					{printf("%s\n", yytext);return '}';}
"$"					{printf("%s\n", yytext);return '$';}

"documentclass"		{printf("%s\n", yytext);return DOCUMENTCLASS;}
"usepackage"		{printf("%s\n", yytext);return USEPACKAGE;}
"title"				{printf("%s\n", yytext);return TITLE;}
"author"			{printf("%s\n", yytext);return AUTHOR;}
"maketitle"			{printf("%s\n", yytext);return MAKETITLE;}
"textbf"			{printf("%s\n", yytext);return TEXTBF;}
"textit"			{printf("%s\n", yytext);return TEXTIT;}
"begin"				{printf("%s\n", yytext);return BGN;}
"document"			{printf("%s\n", yytext);return DOCUMENT;}
"itemize"			{printf("%s\n", yytext);return ITEMIZE;}
"thebibliography"	{printf("%s\n", yytext);return THEBIBLIOGRAPHY;}
"item"				{printf("%s\n", yytext);return ITEM;}
"includegraphics"	{printf("%s\n", yytext);return INCLUDEGRAPHICS;}
"cite"				{printf("%s\n", yytext);return CITE;}
"bibitem"			{printf("%s\n", yytext);return BIBITEM;}
"end"				{printf("%s\n", yytext);return END;}

[a-zA-Z0-9+\-*/.,:]*	{printf("%s\n", yytext);yylval.str = (char*)strdup(yytext);
				 	 return STRING;}

.					{printf("erro: leitura do caracter %c na entrada\n", yytext[0]);}

%%