main:
	ocamlbuild -use-ocamlfind sudoku.byte -tag thread
	./sudoku.byte > sudoku.z3
	z3 sudoku.z3 > sudoku_output.txt

	ocamlbuild -use-ocamlfind parse_output.byte -tag thread
	./parse_output.byte < sudoku_output.txt

clean:
	rm -f sudoku.byte
	rm -f parse_output.byte 
	rm -f sudoku.z3
	rm -f sudoku_output.txt