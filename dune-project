(lang dune 3.4)

(name wcec)

(using menhir 2.1)

(package (name wcec)
 (depends dune menhir))

(generate_opam_files true)