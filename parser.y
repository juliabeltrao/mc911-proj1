%{
#include <stdio.h>
#include <stdlib.h>
%}

%union{
	char *str;
}


%token '['
%token ']'
%token '{'
%token '}'
%token '$'
%token DOCUMENTCLASS
%token USEPACKAGE
%token TITLE
%token AUTHOR
%token MAKETITLE
%token TEXTBF
%token TEXTIT
%token BEGIN_DOCUMENT
%token BEGIN_ITEM
%token BEGIN_BIBL
%token ITEM
%token INCLUDEGRAPHICS
%token CITE
%token BIBITEM
%token END_DOCUMENT
%token END_ITEM
%token END_BIBL
%token <str> WHITESPACE
%token <str> STRING

%type <str> text

%start structure

%error-verbose

%%

structure:	header BEGIN_DOCUMENT body END_DOCUMENT
		 |	BEGIN_DOCUMENT body END_DOCUMENT
;

docclass:	DOCUMENTCLASS '[' text ']' '{' text '}' {printf("docclass\n");}
		 |	DOCUMENTCLASS '{' text '}' {printf("docclass\n");}
		 |	DOCUMENTCLASS '[' text ']' '{' text '}' WHITESPACE {printf("docclass\n");}
		 |	DOCUMENTCLASS '{' text '}' WHITESPACE {printf("docclass\n");}
;

usepack:	USEPACKAGE '[' text ']' '{' text '}' {printf("usepack\n");}
		 |	USEPACKAGE '{' text '}' {printf("usepack\n");}
		 |	USEPACKAGE '[' text ']' '{' text '}' WHITESPACE {printf("usepack\n");}
		 |	USEPACKAGE '{' text '}' WHITESPACE {printf("usepack\n");}
;

ttle:		TITLE '{' text '}' {printf("ttle\n");}
		 |	TITLE '{' text '}' WHITESPACE {printf("ttle\n");}
;

authr:		AUTHOR '{' text '}' {printf("authr\n");}
		 |  AUTHOR '{' text '}' WHITESPACE {printf("authr\n");}
;

mkttle:		MAKETITLE	{printf("mkttle\n");}
;

txtbf:		TEXTBF '{' text '}' {printf("txtbf\n");}
;

txtit:		TEXTIT '{' text '}' {printf("txtit\n");}
;

itemz:		BEGIN_ITEM items END_ITEM {printf("itemz\n");}
;

incgraph:	INCLUDEGRAPHICS '{' text '}' {printf("incgraph\n");}
;

cte:		CITE '{' text '}' {printf("cte\n");}
;

bblgphy:	BEGIN_BIBL bibitm END_BIBL {printf("bblgphy\n");}
;

items:		items ITEM text {printf("items\n");}
		 |	items ITEM '[' text ']' text {printf("items\n");}
		 |	ITEM text {printf("items\n");}
		 |	ITEM '[' text ']' text {printf("items\n");}
;

bibitm:		bibitm BIBITEM text {printf("bibitm\n");}
		 |	BIBITEM text {printf("bibitm\n");}
;

text:	 	text STRING {printf("text\n");}
		 |	text WHITESPACE {printf("text\n");}
		 |	STRING {printf("text\n");}
		 |	WHITESPACE {printf("text\n");}
;

math:	 	'$' text '$'
;

header:		header docclass {printf("header step\n");}
		 |	header usepack {printf("header step\n");}
		 |	header ttle {printf("header step\n");}
		 |	header authr {printf("header step\n");}
		 | 	docclass {printf("header\n");}
		 |	usepack {printf("header\n");}
		 |	ttle {printf("header\n");}
		 |	authr {printf("header\n");}
;

body:		body mkttle {printf("body\n");}
		 |	body txtbf {printf("body\n");}
		 |	body txtit {printf("body\n");}
		 |	body itemz {printf("body\n");}
		 |	body incgraph {printf("body\n");}
		 |	body cte {printf("body\n");}
		 |	body bblgphy {printf("body\n");}
		 |	body text {printf("body\n");}
		 |	body math {printf("body\n");}
		 |	mkttle {printf("body\n");}
		 |	txtbf {printf("body\n");}
		 |	txtit {printf("body\n");}
		 |	itemz {printf("body\n");}
		 |	incgraph {printf("body\n");}
		 |	cte {printf("body\n");}
		 |	bblgphy {printf("body\n");}
		 |	text {printf("body\n");}
		 |	math {printf("body\n");}
;

%%

int yyerror(const char* errmsg){

	printf("\n*** Erro: %s\n", errmsg);

	return 0;
}


int main(){
	
	yyparse();

	return 0;
}
