open Core;;
let initial_board =
    [[0; 0; 4;  8; 0; 0;  0; 1; 7];
    [6; 7; 0;  9; 0; 0;  0; 0; 0];
    [5; 0; 8;  0; 3; 0;  0; 0; 4];
    [3; 0; 0;  7; 4; 0;  1; 0; 0];
    [0; 6; 9;  0; 0; 0;  7; 8; 0];
    [0; 0; 1;  0; 6; 9;  0; 0; 5];
    [1; 0; 0;  0; 8; 0;  3; 0; 6];
    [0; 0; 0;  0; 0; 6;  0; 9; 1];
    [2; 4; 0;  0; 0; 1;  5; 0; 0]];;

let square_to_variable i j = "board_" ^ (string_of_int i) ^ "_" ^ (string_of_int j)

(* Phase 1: declare all the variables *)
let _ = 
    (for i = 0 to 8 do
        (for j = 0 to 8 do 
            let square_name = square_to_variable i j in
            print_string ("(declare-const " ^ square_name ^ " Int)\n");
            print_string ("(assert (>= " ^ square_name ^ " 1))\n");
            print_string ("(assert (<= " ^ square_name ^ " 9))\n");
        done)
    done)

(* Phase 2: ensure all the rows, columns, and 9x9 squares are distinct *)
(* the rows *)
let _ =
    (for i = 0 to 8 do 
        let row = List.init ~f:ident 9 in 
        let square_names = List.map ~f:(square_to_variable i) row in
        print_string ("(assert (distinct " ^ (String.concat ~sep:" " square_names) ^ "))\n");
    done)

(* the columns *)
let _ =
    (for i = 0 to 8 do 
        let col = List.init ~f:ident 9 in 
        let square_names = List.map ~f:(fun x -> square_to_variable x i) col in
        print_string ("(assert (distinct " ^ (String.concat ~sep:" " square_names) ^ "))\n");
    done)

(* the 3*3 squares *)
let _ = 
    (for i = 0 to 2 do 
        for j = 0 to 2 do
            let grid = List.init ~f:ident 9 in
            let square_names = List.map ~f:(fun x -> square_to_variable (3*i+x/3) (3*j+x%3)) grid in
            print_string ("(assert (distinct " ^ (String.concat ~sep:" " square_names) ^ "))\n");
        done
    done)
    
(* Phase 3: match the non-empty squares with their value *)
let _ = 
    List.iteri ~f:(fun i row ->
        (List.iteri ~f:(fun j ele -> 
            if (ele <> 0) then (print_string ("(assert (= " ^ square_to_variable i j ^ " " ^ (ele |> string_of_int) ^ "))\n"))
        ) row)
    ) initial_board

(* Finally, check-sat and get-model *)
let _ = 
    print_string "(check-sat)\n";
    print_string "(get-model)"