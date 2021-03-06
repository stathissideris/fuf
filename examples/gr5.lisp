;;; -*- Mode:Lisp; Syntax:Common-Lisp; Package:FUG5 -*-
;;; ------------------------------------------------------------
;;; File        : GR5.L
;;; Description : grammar to perform something like a prolog append
;;; Author      : Michael Elhadad
;;; Created     : 20-Jun-88
;;; Modified    : 18 May 90
;;; Language    : Common Lisp
;;; Package     : FUG5
;;; ------------------------------------------------------------

(in-package "FUG5")

(defun gsetup5 ()
  ;; No type declaration in effect.
  (clear-bk-class)
  (reset-typed-features)
  (setq *u-grammar*
        '((alt
           (((cat append)
             (alt append
	      ;; First branch: append([],Y,Y).
              (((x none) 
		(z {^ y})
		;; This is to normalize the result of a (cat append):
		;; it must contain the CAR and CDR of the result.
		(car {^ z car})
		(cdr {^ z cdr}))

	       ;; Second branch: append([X/Xs],Y,[X/Z]):-append(Xs,Y,Z).
               ((alt (((x ((car any))))   ; this alt allows for partially
		      ((x ((cdr any)))))) ; defined lists X in input.
		;; recursive call to append
		;; with new arguments x, y and z.
		(cset (z))
                (z ((car {^ ^ x car})
		    (cdr ((cat append)
			  (x {^ ^ ^ x cdr})
			  (y {^ ^ ^ y})))))
		(car {^ z car})
		(cdr {^ z cdr})))))
	    ((cat member)
	     (alt member
	       (((x {^ y car}))
		((y ((cdr any)))
		 (m ((cat member)
		     (x {^ ^ x})
		     (y {^ ^ y cdr})))))))))))

  (format t "~%gr5 installed. List operations.~%")
  (values))


