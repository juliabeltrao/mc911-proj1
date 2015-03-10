FLEX_OBJ 	= scanner
BISON_OBJ	= parser
TARGET		= p

all:
	bison -v -d $(BISON_OBJ).y -o $(BISON_OBJ).c
	flex -o $(FLEX_OBJ).c $(FLEX_OBJ).l
	gcc scanner.c parser.c -o $(TARGET)

clean:
	rm -rf $(BISON_OBJ).c $(BISON_OBJ).h $(FLEX_OBJ).c $(BISON_OBJ).output $(TARGET)