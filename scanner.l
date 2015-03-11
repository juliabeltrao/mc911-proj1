%{
#include "parser.h"
%}

%option noyywrap

%%

"["							{printf("%s\n", yytext);return '[';}
"]"							{printf("%s\n", yytext);return ']';}
"{"							{printf("%s\n", yytext);return '{';}
"}"							{printf("%s\n", yytext);return '}';}
"$"							{printf("%s\n", yytext);return '$';}
"\\$"						{printf("%s\n", yytext);yylval.str = "$";
							 return STRING;}

"\\documentclass"			{printf("%s\n", yytext);return DOCUMENTCLASS;}
"\\usepackage"				{printf("%s\n", yytext);return USEPACKAGE;}
"\\title"					{printf("%s\n", yytext);return TITLE;}
"\\author"					{printf("%s\n", yytext);return AUTHOR;}
"\\maketitle"				{printf("%s\n", yytext);return MAKETITLE;}
"\\textbf"					{printf("%s\n", yytext);return TEXTBF;}
"\\textit"					{printf("%s\n", yytext);return TEXTIT;}
"\\begin{document}"			{printf("%s\n", yytext);return BEGIN_DOCUMENT;}
"\\begin{itemize}"			{printf("%s\n", yytext);return BEGIN_ITEM;}
"\\begin{thebibliography}"	{printf("%s\n", yytext);return BEGIN_BIBL;}
"\\item"					{printf("%s\n", yytext);return ITEM;}
"\\includegraphics"			{printf("%s\n", yytext);return INCLUDEGRAPHICS;}
"\\cite"					{printf("%s\n", yytext);return CITE;}
"\\bibitem"					{printf("%s\n", yytext);return BIBITEM;}
"\\end{document}"			{printf("%s\n", yytext);return END_DOCUMENT;}
"\\end{itemize}"			{printf("%s\n", yytext);return END_ITEM;}
"\\end{thebibliography}"	{printf("%s\n", yytext);return END_BIBL;}
"\\Omega"					{printf("%s\n", yytext);yylval.str = (char*)strdup(yytext);
							 return STRING;}

[ \r\t\n]+					{printf("%s\n", yytext); yylval.str = (char*)strdup(yytext);
						 	 return WHITESPACE;}
[a-zA-Z0-9+\-*/.,:()]+		{printf("string: %s\n", yytext);yylval.str = (char*)strdup(yytext);
				 	 	 	 return STRING;}

.							{printf("erro: leitura do caracter %c na entrada\n", yytext[0]);}

%%
