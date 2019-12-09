CXX		=	gcc 
EXE		=   stego
OBJ_DIR	=	objs

CFLAGS = -g 

all: $(EXE)

$(EXE): $(OBJ_DIR)/main.o $(OBJ_DIR)/bmp_parser.o $(OBJ_DIR)/decoder.o $(OBJ_DIR)/grouping.o $(OBJ_DIR)/embed.o
	$(CXX) $^ $(CFLAGS) -o $@
	
$(OBJ_DIR)/main.o: main.c bmp_parser.h embed.h decoder.h | obj_dir
	$(CXX) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/embed.o: embed.c embed.h grouping.h | obj_dir
	$(CXX) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/grouping.o: grouping.c grouping.h | obj_dir
	$(CXX) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/decoder.o: decoder.c decoder.h | obj_dir
	$(CXX) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/bmp_parser.o: bmp_parser.c bmp_parser.h | obj_dir
	$(CXX) $(CFLAGS) -c $< -o $@

obj_dir:
	mkdir -p $(OBJ_DIR)

clean:
	rm -rf *.gch objs/
