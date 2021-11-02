open Core
open Stdio

let get_lines () : string list =
  let line = In_channel.stdin in 
  In_channel.fold_lines line ~init:[] ~f:(fun lines l ->
    l :: lines
  )

let empty_grid = Array.make_matrix 9 9 0
let process =
  let all_lines = get_lines () |> List.tl_exn |> List.rev in
  let content = all_lines |> List.tl_exn |> List.tl_exn in
  if String.equal "sat" (List.hd_exn all_lines) then 
    let stripped_content = 
      content |>
        List.mapi ~f:(fun i e -> 
          if i%2 = 0 then (int_of_char (String.get e 20) - 48, int_of_char (String.get e 22) - 48)
          else (int_of_char (String.get e 4) - 48, -1)
        )
    in 
    let indices = List.filteri ~f:(fun x _ -> x%2 = 0) stripped_content in
    let values = List.filteri ~f:(fun x _ -> x%2 = 1) stripped_content in
    let paired_list = List.zip_exn indices values in
    List.iter paired_list ~f:(fun ((i, j), (v, _)) ->
      (empty_grid.(i).(j) <- v));
    true
  else false

let main = 
  if process then 
    (print_string "Solution found!\n";
    for i = 0 to 8 do 
      (for j = 0 to 8 do 
        (print_string ((empty_grid.(i).(j) |> string_of_int) ^ " "));
      done);
      print_string "\n"
    done)
  else (print_string "No solution found!")