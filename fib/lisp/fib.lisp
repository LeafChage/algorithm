(defun fib (n)
  (cond ((<= n 1) n)
        (t (+ (fib (- n 2)) (fib (- n 1))))))
