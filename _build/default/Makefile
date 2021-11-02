main:
	ocamlbuild -use-ocamlfind sudoku.byte -tag thread
	./sudoku.byte > sudoku.z3
	z3 sudoku.z3 > sudoku_output.txt

output:
	ocamlbuild -use-ocamlfind parse_output.byte -tag thread
	./parse_output.byte