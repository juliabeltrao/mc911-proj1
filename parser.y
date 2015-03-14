%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

typedef struct reference_s{
	int num;
	char *label;
	struct reference_s *next;
} reference_t;

extern FILE *yyin;
extern int yylineno;

char *title = NULL;

char *doc = NULL;

reference_t *refs = NULL;

int ref_num = 1;

char *concat(int count, ...);

void add_ref(char *s);

int get_ref(char *s);

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

%type <str> header_list header body_list body docclass usepack ttle authr mkttle txtbf
%type <str> txtit itemz incgraph cte bblgphy text_list math text item_list items bibitm

%start structure

%error-verbose

%%

/* visao top level do arquivo LaTex */
structure:	header_list BEGIN_DOCUMENT body_list END_DOCUMENT {doc = (char*)concat(4, $1, "\\begin{document}", $3, "\\end{document}");}
		 |	BEGIN_DOCUMENT body_list END_DOCUMENT {doc = (char*)concat(3, "\\begin{document}", $2, "\\end{document}");}
		 |	header_list BEGIN_DOCUMENT body_list END_DOCUMENT WHITESPACE {doc = (char*)concat(4, $1, "\\begin{document}", $3, "\\end{document}");}
		 |	BEGIN_DOCUMENT body_list END_DOCUMENT WHITESPACE {doc = (char*)concat(3, "\\begin{document}", $2, "\\end{document}");}
;

/* gera a lista de itens do cabecalho */
header_list:
			header_list header {$$ = (char*)concat(2, $$, $2);}
		|	header_list WHITESPACE {$$ = (char*)concat(2, $$, $2);}
		|	header {$$ = $1;}
;

/* possiveis itens do cabecalho */
header:		docclass {$$ = $1;}
		 |	usepack {$$ = $1;}
		 |	ttle {$$ = $1;}
		 |	authr {$$ = $1;}
;

/* gera a lista de itens do corpo do documento */
body_list:	body_list body {$$ = (char*)concat(2, $$, $2);}
		 |	body {$$ = $1;}
;

/* possiveis itens do corpo do documento */
body:		mkttle {$$ = $1;}
		 |	txtbf {$$ = $1;}
		 |	txtit {$$ = $1;}
		 |	itemz {$$ = $1;}
		 |	incgraph {$$ = $1;}
		 |	cte {$$ = $1;}
		 |	bblgphy {$$ = $1;}
		 |	text_list {$$ = $1;}
		 |	math {$$ = $1;}
;

/* descricao dos itens do cabecalho */
docclass:	DOCUMENTCLASS '[' text_list ']' '{' text_list '}' {$$ = (char*)concat(5, "\\documentclass[", $3, "]{", $6, "}");}
		 |	DOCUMENTCLASS '{' text_list '}' {$$ = (char*)concat(3, "\\documentclass{", $3, "}");}
;

usepack:	USEPACKAGE '[' text_list ']' '{' text_list '}' {$$ = (char*)concat(5, "\\usepackage[", $3, "]{", $6, "}");}
		 |	USEPACKAGE '{' text_list '}' {$$ = (char*)concat(3, "\\usepackage{", $3, "}");}
;

ttle:		TITLE '{' text_list '}' {title = (char*)strdup($3); $$ = (char*)concat(3, "\\title{", $3, "}");}
;

authr:		AUTHOR '{' text_list '}' {$$ = (char*)concat(3, "\\author{", $3, "}");}
;
/* fim da descricao dos itens do cabecalho */

/* descricao dos itens do corpo do documento */
mkttle:		MAKETITLE	{$$ = "\\maketitle";}
;

txtbf:		TEXTBF '{' text_list '}' {$$ = (char*)concat(3, "\\textbf{", $3, "}");}
;

txtit:		TEXTIT '{' text_list '}' {$$ = (char*)concat(3, "\\textit{", $3, "}");}
;

itemz:		BEGIN_ITEM item_list END_ITEM {$$ = (char*)concat(3, "\\begin{itemize}", $2, "\\end{itemize}");}
		 //|	BEGIN_ITEM WHITESPACE item_list END_ITEM {$$ = (char*)concat(4, "\\begin{itemize}", $2, $3, "\\end{itemize}");}
;

incgraph:	INCLUDEGRAPHICS '{' text_list '}' {$$ = (char*)concat(3, "\\includegraphics{", $3, "}");}
;

cte:		CITE '{' text_list '}' {$$ = (char*)concat(3, "\\cite{", $3, "}");}
;

bblgphy:	BEGIN_BIBL bibitm END_BIBL {$$ = (char*)concat(3, "\\begin{bibliography}", $2, "\\end{bibliography}");}
		 |	BEGIN_BIBL WHITESPACE bibitm END_BIBL {$$ = (char*)concat(4, "\\begin{bibliography}", $2, $3, "\\end{bibliography}");}
;

text_list: 	text_list text {$$ = (char*)concat(2,$$, $2);}
		 |	text {$$ = $1;}
;

math:	 	'$' text_list '$' {$$ = (char*)concat(3, "$", $2, "$");}
;
/* fim da descricao dos itens do corpo do documento */

text:	 	STRING {$$ = $1;}
		 |	WHITESPACE {$$ = $1;}
;

item_list:	item_list items {$$ = (char*)concat(2, $$, $2);}
		 |	items {$$ = $1;} 
;		

items:		ITEM text_list {$$ = (char*)concat(2, "\\item", $2);}
		 |	ITEM '[' text_list ']' text_list {$$ = (char*)concat(4, "\\item[", $3, "]", $5);}
		 |	itemz {$$ = $1;}
		 |  WHITESPACE
;

bibitm:		bibitm BIBITEM '{' text_list '}' text_list {$$ = (char*)concat(5, $$, "\\bibitem{", $4, "}", $6); add_ref($4);}
		 |	BIBITEM '{' text_list '}' text_list {$$ = (char*)concat(4, "\\bibitem{", $3, "}", $5); add_ref($3);}
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

	printf("\n*** Erro:%d: %s\n", yylineno, errmsg);

	return 0;
}

void add_ref(char *s){

	reference_t *aux;

	aux = (reference_t*)malloc(sizeof(reference_t));
	aux->num = ref_num;
	aux->label = strdup(s);

	if(refs != NULL)
		aux->next = refs;
	else
		aux->next = NULL;
	
	refs = aux;

	ref_num++;
}

int get_ref(char *s){

	reference_t *i;

	for(i = refs; i != NULL; i = i->next){
		if(!strcmp(s, i->label))
			return i->num;
	}

	return -1;
}

void destroy_ref(){

	reference_t *i, *aux;

	i = refs;
	while(i != NULL){
		aux = i;
		i = i->next;
		free(aux->label);
		free(aux);
	}
}


int main(int argc, char *argv[]){
	
	FILE *input = NULL;
	FILE *output = NULL;
	char *outname = NULL;
	reference_t *i;

	if(argc != 2 && argc != 3){
		printf("Numero de argumentos invalido.\nUso:\n\t%s arquivo.tex [saida]\n", argv[0]);
		exit(0);
	}

	if(argc == 3){
		outname = strdup(argv[2]);
	}
	else{
		outname = strdup(argv[1]);
		outname[strlen(outname) - 3] = '\0';
		outname = (char*)concat(2, outname, "html");
	}

	input = fopen(argv[1], "r");

	if(input == NULL){
		printf("Erro:%d: nao foi possivel abrir o arquivo %s\n", argv[1]);
		exit(0);
	}


	yyin = input;

	while(!feof(yyin))
		yyparse();

for(i = refs; i != NULL; i = i->next){
	printf("[%d]%s\n", i->num, i->label);
}

	output = fopen(outname, "w");

	if(output == NULL){
		printf("Erro: nao foi possivel abrir o arquivo %s\n", outname);
		exit(0);
	}

	fprintf(output, "%s", doc);

	printf("DOCUMENT:\n%s\n", doc);

	destroy_ref();

	return 0;
}
