%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "intermediate.h"

char *title = NULL;

char *concat(int count, ...);

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
			header_list header
		|	header_list WHITESPACE
		|	header
;

/* possiveis itens do cabecalho */
header:		docclass
		 |	usepack
		 |	ttle
		 |	authr
;

/* gera a lista de itens do corpo do documento */
body_list:	body_list body {}
		 |	body {}
;

/* possiveis itens do corpo do documento */
body:		mkttle {}
		 |	txtbf {}
		 |	txtit {}
		 |	itemz {}
		 |	incgraph {}
		 |	cte {}
		 |	bblgphy {}
		 |	text_list {}
		 |	math {}
;

/* descricao dos itens do cabecalho */
docclass:	DOCUMENTCLASS '[' text_list ']' '{' text_list '}' {}
		 |	DOCUMENTCLASS '{' text_list '}' {}
;

usepack:	USEPACKAGE '[' text_list ']' '{' text_list '}' {}
		 |	USEPACKAGE '{' text_list '}' {}
;

ttle:		TITLE '{' text_list '}' {title = (char*)strdup($3);}
;

authr:		AUTHOR '{' text_list '}' {}
;
/* fim da descricao dos itens do cabecalho */

/* descricao dos itens do corpo do documento */
mkttle:		MAKETITLE	{}
;

txtbf:		TEXTBF '{' text_list '}' {}
;

txtit:		TEXTIT '{' text_list '}' {}
;

itemz:		BEGIN_ITEM item_list END_ITEM {}
		 |	BEGIN_ITEM WHITESPACE item_list END_ITEM {}
;

incgraph:	INCLUDEGRAPHICS '{' text_list '}' {}
;

cte:		CITE '{' text_list '}' {}
;

bblgphy:	BEGIN_BIBL bibitm END_BIBL {}
		 |	BEGIN_BIBL WHITESPACE bibitm END_BIBL {}
;

text_list: 	text_list text {$$ = concat(2,$$, $2);}
		 |	text {$$ = $1;}
;

math:	 	'$' text_list '$' {}
;
/* fim da descricao dos itens do corpo do documento */

text:	 	STRING {$$ = $1;}
		 |	WHITESPACE {$$ = $1;}
;

item_list:	item_list items {}
		 |	items {} 
;		

items:		ITEM text_list {}
		 |	ITEM '[' text_list ']' text_list {}
		 |	itemz {}
;

bibitm:		bibitm BIBITEM '{' text_list '}' text_list {}
		 |	BIBITEM '{' text_list '}' text_list {}
;

%%

char* concat(int count, ...){

    va_list ap;
    int len = 1, i;

    va_start(ap, count);
    for(i=0 ; i<count ; i++)
        len += strlen(va_arg(ap, char*));
    va_end(ap);

    char *result = (char*) calloc(sizeof(char),len);
    int pos = 0;

    // Actually concatenate strings
    va_start(ap, count);
    for(i=0 ; i<count ; i++)    {
        char *s = va_arg(ap, char*);
        strcpy(result+pos, s);
        pos += strlen(s);
    }
    va_end(ap);

    return result;
}

int yyerror(const char* errmsg){

	printf("\n*** Erro: %s\n", errmsg);

	return 0;
}


int main(){
	
	ir_tree->id = nothing;
	ir_tree->content = NULL;
	ir_tree->children = NULL;
	ir_tree->tail = NULL;
	ir_tree->father = NULL
	node = &ir_tree;
	
	yyparse();

	return 0;
}
