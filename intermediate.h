#ifndef __INTERMEDIATE_H__
#define __INTERMEDIATE_H__

typedef enum{
	nothing
	title,
	math,
	begin_doc,
	end_doc,
	maketitle,
	textbf,
	textit,
	begin_itemize,
	end_itemize,
	item,
	inc_graph,
	cite,
	begin_bibl,
	end_bibl,
	bib_item
} block_t;

typedef struct ir_s{
	block_t id;
	char *content;
	struct child_s *children, *tail;
	struct ir_s *father;
} ir_t;

typedef struct child_s{
	ir_t *node;
	struct child_s *next;	
} child_t;

ir_t ir_tree, *node = NULL;

void inc_brother(block_t tipo, char *s);

void inc_son(block_t tipo, char *s);

#endif
