(*
 * Copyright (c) 2021 Craig Ferguson <craig@tarides.com>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)

(** Extensions to the default namespace, opened throughout the Irmin codebase. *)

module Option = struct
  include Option

  let of_result = function Ok x -> Some x | Error _ -> None
end

module Seq = struct
  include Seq

  let rec drop : type a. int -> a t -> a t =
   fun n l () ->
    match l () with
    | l' when n = 0 -> l'
    | Nil -> Nil
    | Cons (_, l') -> drop (n - 1) l' ()

  let take : type a. int -> a t -> a list =
    let rec aux acc n l =
      if n = 0 then acc
      else
        match l () with Nil -> acc | Cons (x, l') -> aux (x :: acc) (n - 1) l'
    in
    fun n s -> List.rev (aux [] n s)
end

type read = Perms.read
type write = Perms.write
type read_write = Perms.read_write

let ( >>= ) = Lwt.Infix.( >>= )
let ( >|= ) = Lwt.Infix.( >|= )
let ( let* ) = ( >>= )
let ( let+ ) = ( >|= )
