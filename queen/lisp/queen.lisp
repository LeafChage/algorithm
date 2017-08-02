(defclass queen ()
  ( num
    count
    result))

(defmethod init ((q queen) n)
  (setf (slot-value q 'num) n)
  (setf (slot-value q 'count) 0)
  (setf (slot-value q 'result) nil)
  (let ((i 0))
    (loop
      (push 'nil (slot-value q 'result))
      (setf i (+ i 1))
      (when (>= i n) (return)))))

(defmethod run ((q queen) y)
  (let ((x 0))
    (loop
      (init_array q y)
      (when (can_put q x y)
        (progn
          (put q x y)
          (if (>=  y (- (slot-value q 'num) 1))
              (progn
                (setf (slot-value q 'count) (+ (slot-value q 'count) 1))
                (write_field q))
              (run q (+ y 1))) ) )
      (setf x (+ x 1))
      (when (>= x (slot-value q 'num)) (return))))
  nil)

(defmethod init_array ((q queen) y)
  (let ((i 0))
    (loop
      (when (>= i y)
        (setf (nth i (slot-value q 'result)) nil))
      (setf i (+ i 1))
      (when (>= i (slot-value q 'num)) (return)))))

(defmethod can_put ((q queen) x y)
  (if (and (null (nth y (slot-value q 'result)))
           (null (is_include q x))
           (slant_check q x y))
      t
      nil))

(defmethod slant_check ((q queen) x y)
  (let ((tmp1 (- y x))
        (tmp2 (+ y x))
        (i 0)
        (tmp t))
    (loop
      (when (and (not (null (nth i (slot-value q 'result))))
                 (or (= i (+ (nth i (slot-value q 'result))  tmp1)) (= i (+ (* (nth i (slot-value q 'result))  -1) tmp2))))
        (setf tmp nil))
      (setf i (+ i 1))
      (when (>= i (slot-value q 'num)) (return)))
    tmp ))

(defmethod write_field ((q queen))
  (let ((i 0)
        (j 0))
    (loop
      (setf j 0 )
      (loop
        (if (and (not (null (nth i (slot-value q 'result))))
                 (= (nth i (slot-value q 'result)) j))
            (princ "Q ")
            (princ "_ "))
        (setf j (+ j 1))
        (when (>= j (slot-value q 'num)) (return)))
      (terpri)
      (setf i (+ i 1))
      (when (>= i (slot-value q 'num)) (return)))
    (print (slot-value q 'count))
    (terpri)))

(defmethod is_include ((q queen) x)
  (let ((i 0)
        (tmp nil))
    (loop
      (when (and (not (null (nth i (slot-value q 'result))))
                 (= (nth i (slot-value q 'result)) x))
        (setf tmp t))
      (setf i (+ i 1))
      (when (>= i (slot-value q 'num)) (return)))
    tmp ))

(defmethod put ((q queen) x y)
  (setf (nth y (slot-value q 'result)) x))


(defun main ()
  (let ((qu (make-instance 'queen)))
    (init qu 13)
    (run qu 0)))

(sb-ext:save-lisp-and-die "queen"
                          :toplevel #'main
                          :executable t)
