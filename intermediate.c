#include "intermediate.h"

void inc_brother(block_t tipo, char *s){

	ir_t *aux = (ir_t*)malloc(ir_t);
	
	if(aux == NULL){
		printf("malloc error!\n");
		exit(0);
	}
	
	aux->id = tipo;
	aux->content = strdup(s);
	aux->children = NULL;
	aux->tail = NULL;
	aux->father = node->father;

	if(node->children == NULL){
		node->children = aux;
		node->tail
	}
	}

}

void inc_son(block_t tipo, char *s);{


}
