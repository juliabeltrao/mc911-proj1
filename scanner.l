%{
#include "parser.h"

int i, size;
%}

%option noyywrap

%%

"["							{return '[';}
"]"							{return ']';}
"{"							{return '{';}
"}"							{return '}';}
"$"							{return '$';}
"\\$"						{yylval.str = "$";
							 return STRING;}

"\\documentclass"			{return DOCUMENTCLASS;}
"\\usepackage"				{return USEPACKAGE;}
"\\title"					{return TITLE;}
"\\author"					{return AUTHOR;}
"\\maketitle"				{return MAKETITLE;}
"\\textbf"					{return TEXTBF;}
"\\textit"					{return TEXTIT;}
"\\begin{document}"			{return BEGIN_DOCUMENT;}
"\\begin{itemize}"			{return BEGIN_ITEM;}
"\\begin{thebibliography}"	{return BEGIN_BIBL;}
"\\item"					{return ITEM;}
"\\includegraphics"			{return INCLUDEGRAPHICS;}
"\\cite"					{return CITE;}
"\\bibitem"					{return BIBITEM;}
"\\end{document}"			{return END_DOCUMENT;}
"\\end{itemize}"			{return END_ITEM;}
"\\end{thebibliography}"	{return END_BIBL;}
"\\Omega"					{yylval.str = (char*)strdup(yytext);
							 return STRING;}

[ \r\t\n]+					{yylval.str = (char*)strdup(yytext);size = strlen(yytext);
							 for(i = 0; i <size; i++){
							 	if(yytext[i] == '\n')
							 		yylineno++;
							 }
						 	 return WHITESPACE;}
[a-zA-Z0-9+\-*/.,:()]+		{yylval.str = (char*)strdup(yytext); 
				 	 	 	 return STRING;}

.							{printf("Erro:%d: leitura do caracter %c na entrada\n", yylineno, yytext[0]);}

%%
