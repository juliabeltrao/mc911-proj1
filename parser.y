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
%type <str> text_list

%start structure

%error-verbose

%%

/* visao top level do arquivo LaTex */
structure:	header_list BEGIN_DOCUMENT body_list END_DOCUMENT
		 |	BEGIN_DOCUMENT body_list END_DOCUMENT
		 |	header_list BEGIN_DOCUMENT body_list END_DOCUMENT WHITESPACE
		 |	BEGIN_DOCUMENT body_list END_DOCUMENT WHITESPACE
;

/* gera a lista de itens do cabecalho */
header_list:
			header_list header {printf("header_list\n");}
		|	header_list WHITESPACE {printf("header_list\n");}
		|	header {printf("header_list\n");}
;

/* possiveis itens do cabecalho */
header:		docclass {printf("header\n");}
		 |	usepack {printf("header\n");}
		 |	ttle {printf("header\n");}
		 |	authr {printf("header\n");}
;

/* gera a lista de itens do corpo do documento*/
body_list:	body_list body {printf("body\n");}
		 |	body {printf("body\n");}
;

/* possiveis itens do corpo do documento */
body:		mkttle {printf("body\n");}
		 |	txtbf {printf("body\n");}
		 |	txtit {printf("body\n");}
		 |	itemz {printf("body\n");}
		 |	incgraph {printf("body\n");}
		 |	cte {printf("body\n");}
		 |	bblgphy {printf("body\n");}
		 |	text_list {printf("body\n");}
		 |	math {printf("body\n");}
;

/* descricao dos itens do cabecalho */
docclass:	DOCUMENTCLASS '[' text_list ']' '{' text_list '}' {printf("docclass\n");}
		 |	DOCUMENTCLASS '{' text_list '}' {printf("docclass\n");}
;

usepack:	USEPACKAGE '[' text_list ']' '{' text_list '}' {printf("usepack\n");}
		 |	USEPACKAGE '{' text_list '}' {printf("usepack\n");}
;

ttle:		TITLE '{' text_list '}' {printf("ttle\n");}
;

authr:		AUTHOR '{' text_list '}' {printf("authr\n");}
;
/* fim da descricao dos itens do cabecalho */

/* descricao dos itens do corpo do documento */
mkttle:		MAKETITLE	{printf("mkttle\n");}
;

txtbf:		TEXTBF '{' text_list '}' {printf("txtbf\n");}
;

txtit:		TEXTIT '{' text_list '}' {printf("txtit\n");}
;

itemz:		BEGIN_ITEM item_list END_ITEM {printf("itemz\n");}
		 |	BEGIN_ITEM WHITESPACE item_list END_ITEM {printf("itemz\n");}
;

incgraph:	INCLUDEGRAPHICS '{' text_list '}' {printf("incgraph\n");}
;

cte:		CITE '{' text_list '}' {printf("cte\n");}
;

bblgphy:	BEGIN_BIBL bibitm END_BIBL {printf("bblgphy\n");}
		 |	BEGIN_BIBL WHITESPACE bibitm END_BIBL {printf("bblgphy\n");}
;

text_list: 	/*text_list text {printf("text_list\n");}
		 |	text {printf("text_list\n");}*/
		 text
;

math:	 	'$' text_list '$'
;
/* fim da descricao dos itens do corpo do documento */

text:	 	STRING {printf("text\n");}
		 |	WHITESPACE {printf("text\n");}
;

item_list:	/*item_list items {printf("item_list\n");}
		 |	item_list WHITESPACE items {printf("item_list\n");}
		 |	items {printf("item_list\n");}*/
		 items
;		

items:		ITEM text_list {printf("items\n");}
		 |	ITEM '[' text_list ']' text_list {printf("items\n");}
		 |	itemz {printf("items\n");}
;

bibitm:		bibitm BIBITEM '{' text_list '}' text_list {printf("bibitm\n");}
		 |	BIBITEM '{' text_list '}' text_list {printf("bibitm\n");}
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
