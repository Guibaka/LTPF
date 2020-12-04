SRC_DIR = src
LIBS_DIR = includes
OBJS_DIR = obj
BIN_DIR = exec
EXEC = $(OBJ_DIR) $(BIN_DIR) main

CC = ocamlc
FLAGS = -g

all : $(EXEC)

$(LIBS_DIR) :
	mkdir $(OBJS_DIR)

$(OBJS_DIR) :
	mkdir $(BIN_DIR)

$(EXEC): $(OBJS_DIR)
	ocamlc -o $(EXEC) $(LIBS_DIR) $(OBJS_DIR)

%.cmo: %.ml
	ocamlc -c $<

%.cmi: %.mli
	ocamlc -c $<

clean:
	rm -r $(OBJS_DIR)/
	rm -r $(BIN_DIR)/

# Ajouter ici les dépendances non automatiques
parseur.cmo: parseur.cmi
state.cmo: state.cmi parseur.cmi
config.cmo: parseur.cmi state.cmi config.cmi
exec.cmo : parseur.cmi state.cmi config.cmi exec.cmi
