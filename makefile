CXX		=	nvcc 
EXE		=   stego
OBJ_DIR	=	objs

CFLAGS = -g 

all: $(EXE)

$(EXE): $(OBJ_DIR)/main.o $(OBJ_DIR)/bmp_parser.o $(OBJ_DIR)/decoder.o $(OBJ_DIR)/grouping.o $(OBJ_DIR)/embed.o $(OBJ_DIR)/convert.o
	$(CXX) $^ $(CFLAGS) -o $@
	
$(OBJ_DIR)/main.o: main.cu bmp_parser.h embed.h decoder.h | obj_dir
	$(CXX) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/convert.o: convert.cu convert.h | obj_dir
	$(CXX) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/embed.o: embed.cu embed.h grouping.h convert.h | obj_dir
	$(CXX) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/grouping.o: grouping.cu grouping.h | obj_dir
	$(CXX) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/decoder.o: decoder.cu decoder.h convert.h | obj_dir
	$(CXX) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/bmp_parser.o: bmp_parser.cu bmp_parser.h | obj_dir
	$(CXX) $(CFLAGS) -c $< -o $@

obj_dir:
	mkdir -p $(OBJ_DIR)

clean:
	rm -rf *.gch objs/
