SRC_DIR = src
LIB_DIR = includes
OBJ_DIR = obj
BIN_DIR = exec
MKDIR = mkdir

CC = ocamlc
FLAGS = -g

all : directories main

directories : $(OBJ_DIR) $(BIN_DIR)

$(OBJ_DIR) :
	$(MKDIR) $(OBJ_DIR)

$(BIN_DIR) :
	$(MKDIR) $(BIN_DIR)
	
main : $(OBJ_DIR)/parseur.cmo $(OBJ_DIR)/funUtil.cmo 
	@echo "Compiling analyser\n"
	$(CC) $^ -o $(BIN_DIR)/$@
	
	
$(OBJ_DIR)/funUtil.cmi : $(LIB_DIR)/funUtil.mli $(OBJ_DIR)/parseur.cmi
	$(CC) -c $(FLAGS) $< -I $(OBJ_DIR)/ -o $@

$(OBJ_DIR)/parseur.cmi : $(LIB_DIR)/parseur.mli
	$(CC) -c $(FLAGS) $< -I $(OBJ_DIR)/ -o $@
	
	
$(OBJ_DIR)/funUtil.cmo : $(SRC_DIR)/funUtil.ml $(OBJ_DIR)/funUtil.cmi $(OBJ_DIR)/parseur.cmo
	$(CC) -c $(FLAGS) $< -I $(OBJ_DIR)/ -o $@

$(OBJ_DIR)/parseur.cmo : $(SRC_DIR)/parseur.ml $(OBJ_DIR)/parseur.cmi
	$(CC) -c $(FLAGS) $< -I $(OBJ_DIR)/ -o $@

clean :
	@echo "Cleaning obj dir and bin dir\n"
	rm -r $(OBJ_DIR)/
	rm -r $(BIN_DIR)/

