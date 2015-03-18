%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#define N 5

typedef struct reference_s{
	int num;
	char *label;
	struct reference_s *next;
} reference_t;

extern FILE *yyin;
extern int yylineno;

FILE *output = NULL;

char *title = NULL;

char *doc = NULL;

char buf[N];

reference_t *refs = NULL;

int ref_num = 1;

char *concat(int count, ...);

void add_ref(char *s);

int get_ref(char *s);

void finalize();

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
structure:	header_list BEGIN_DOCUMENT body_list END_DOCUMENT {doc = (char*)concat(3, "<body>", $3, ",</body>");}
		 |	BEGIN_DOCUMENT body_list END_DOCUMENT {doc = (char*)concat(3, "<body>", $2, "</body>");}
		 |	header_list BEGIN_DOCUMENT body_list END_DOCUMENT WHITESPACE {doc = (char*)concat(3, "<body>", $3, "</body>");}
		 |	BEGIN_DOCUMENT body_list END_DOCUMENT WHITESPACE {doc = (char*)concat(3, "<body>", $2, "</body>");}
;

/* gera a lista de itens do cabecalho */
header_list:
			header_list header {}
		|	header_list WHITESPACE {}
		|	header {}
;

/* possiveis itens do cabecalho */
header:		docclass {}
		 |	usepack {}
		 |	ttle {}
		 |	authr {}
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
		 |	text {$$ = $1;}
		 |	math {$$ = $1;}
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
mkttle:		MAKETITLE	{$$ = (char*)concat(3, "<h1 align=\"center\">", title, "</h1>" );}
;

txtbf:		TEXTBF '{' text_list '}' {$$ = (char*)concat(3, "<b>", $3, "</b>");}
;

txtit:		TEXTIT '{' text_list '}' {$$ = (char*)concat(3, "<i>", $3, "</i>");}
;

itemz:		BEGIN_ITEM item_list END_ITEM {$$ = (char*)concat(3, "<table><ul>", $2, "</ul></table>");}
		 |	BEGIN_ITEM WHITESPACE item_list END_ITEM {$$ = (char*)concat(4, "<table><ul>", $2, $3, "</ul></table>");}
;

incgraph:	INCLUDEGRAPHICS '{' text_list '}' {$$ = (char*)concat(3, "<img src=", $3, ">");}
;

cte:		CITE '{' text_list '}' {$$ = (char*)concat(3, "\\cite{", $3, "}");}
;

bblgphy:	BEGIN_BIBL bibitm END_BIBL {$$ = (char*)concat(3, "<table>", $2, "</table>");}
		 |	BEGIN_BIBL WHITESPACE bibitm END_BIBL {$$ = (char*)concat(4, "<table>", $2, $3, "</table>");}
;

text_list: 	text_list text {$$ = (char*)concat(2,$$, $2);}
		 |	text {$$ = $1;}
;

math:	 	'$' text_list '$' {$$ = (char*)concat(3, "\\(", $2, "\\)");}
;
/* fim da descricao dos itens do corpo do documento */

text:	 	STRING {$$ = $1;}
		 |	WHITESPACE {$$ = $1;}
;

item_list:	item_list items {$$ = (char*)concat(2, $$, $2);}
		 |	items {$$ = $1;} 
;		

items:		ITEM text_list {$$ = (char*)concat(3, "<li>", $2, "</li>");}
		 |	ITEM '[' text_list ']' text_list {$$ = (char*)concat(5, "<tr><td>", $3, "</td><td> ", $5, "</td></tr>");}
		 |	itemz WHITESPACE {$$ = (char*)concat(4, "<li>", $1, $2, "</li>");}
;

bibitm:		bibitm BIBITEM '{' text_list '}' text_list {sprintf(buf, "%d", ref_num); $$ = (char*)concat(6, $$, "<tr><td>[", buf, "]</td><td>", $6, "</td></tr>"); add_ref($4);}
		 |	BIBITEM '{' text_list '}' text_list {sprintf(buf, "%d", ref_num); $$ = (char*)concat(4, "<tr><td>[", buf, "]</td><td>", $5, "</td></tr>"); add_ref($3);}
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

void finalize(){
	
	char *find = NULL;
	char buf[50];
	int i;

	find = strstr(doc, "\\cite{");
	while(find != NULL){
		find[0] = '\0';
		fprintf(output, "%s", doc);
		find += 6;
		for(i = 0; find[i] != '}'; i++){
			buf[i] = find[i];
		}
		buf[i] = '\0';
		fprintf(output, "[%d]", get_ref(buf));
		doc = find + i + 1;
		find = strstr(doc, "\\cite{");
	}
	fprintf(output, "%s", doc);
}


int main(int argc, char *argv[]){
	
	FILE *input = NULL;
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

	output = fopen(outname, "w");

	if(output == NULL){
		printf("Erro: nao foi possivel abrir o arquivo %s\n", outname);
		exit(0);
	}

	yyin = input;

	while(!feof(yyin))
		yyparse();


	for(i = refs; i != NULL; i = i->next){
		printf("[%d]%s\n", i->num, i->label);
	}

	fprintf(output, "<!DOCTYPE html> <html> <head> <title>%s</title> <script type=\"text/x-mathjax-config\"> MathJax.Hub.Config({tex2jax: {inlineMath: [[\'$$\',\'$$\'], [\'\\\\(\',\'\\\\)\']]}}); </script> <script type=\"text/javascript\" src=\"http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML\"> </script> </head>\n", outname);

	finalize();	

	fprintf(output, "\n</html>\n");
	printf("DOCUMENT:\n%s\n", doc);

	destroy_ref();

	return 0;
}
