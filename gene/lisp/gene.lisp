;定数
(defconstant *gene_count* 18)
(defconstant *correct* '(c a r a m e l f r a p p u c h i n o))
(defconstant *alphabet* '(a b c d e f g h i j k l m n o p q r s t u))
(defconstant *generations* 20)
(defconstant *destroy* 5)
(defconstant *mutation_ratio* 25)

(defparameter *flag* nil)

;個体クラス-------------------------------------------------
(defclass individual ()
  ((gene
     :accessor gene)
   (point
     :accessor point)))

(defmethod init ((ind individual))
  (setf (point ind) 0)
  (setf (gene ind) '())
  (loop for i from 0 to (- *gene_count*  1)
        do
        (push (get_alphabet) (gene ind)))
  ind )

(defmethod review ((ind individual))
  (setf (point ind) 0)
  (loop for i from 0 to (- (list-length (gene ind)) 1)
        do
        (when (equal (nth i (gene ind)) (nth i *correct*))
          (setf (point ind) (+ (point ind) 1))))
  (when (>= (point ind) *gene_count*) (setf *flag* t)))

(defmethod mutation ((ind individual))
  (setf (nth (random *gene_count*) (gene ind)) (get_alphabet))
  (setf (nth (random *gene_count*) (gene ind)) (get_alphabet)))

(defun make_child (father mother)
  (let ((child (make-instance 'individual))
        (rnd (random *gene_count*)))
    (init child)
    (loop for i from 0 to (- *gene_count* 1)
          do
          (if (< i rnd)
              (setf (nth i (gene child)) (nth i (gene mother)))
              (setf (nth i (gene child)) (nth i (gene father)))))
    child))

(defun get_alphabet ()
  (nth (random (list-length *alphabet*)) *alphabet*))


;コロニークラス-------------------------------------------------
(defclass colony ()
  ((generation
     :accessor generation)))

(defmethod init ((c colony))
  (setf (generation c) nil)
  (loop for i from 0 to (- *generations*  1)
        do
        (push (init (make-instance 'individual)) (generation c))))

(defmethod reviews ((c colony))
  (dolist (g (generation c))
    (review g)))

(defmethod destroy ((c colony))
  (loop for i from 0 to (- *destroy* 1)
        do
        (let ((s_key 0)
              (s_point 0)
              (j 0))
          (terpri)
          (dolist (g (generation c))
            (cond ((= j 0)
                   (setf s_point (point g)))
                  ((> s_point (point g))
                   (setf s_key j)
                   (setf s_point (point g))))
            (setf j (+ j 1)))
          (setf (generation c) (delete_at (generation  c) s_key)))))

(defmethod make_children ((c colony))
  (loop for i from 0 to (- *destroy* 1)
        do
        (push (make_child (nth (random (- *generations* *destroy* 1)) (generation c))
                          (nth (random (- *generations* *destroy* 1)) (generation c)))
              (generation c))))

(defmethod mutations ((c colony))
  (dolist (g (generation c))
    (when (= 1 (random *mutation_ratio*))
      (mutation g))))

(defun delete_at (l index)
  (let ((tmp '()))
    (loop for i from 0 to (- (list-length l) 1)
          do
          (unless (= i index) (push (nth i l) tmp)))
    tmp))


;-------------------------------------------------------
(defun main ()
  (let ((generations (make-instance 'colony))
        (i 0))
    (init generations)
    (loop
          (reviews generations)
          (dolist (g (generation generations))
            (print (gene g))
            (princ (point g)))
          (when *flag*
            (print i)
            (print "finish")
            (return))
          (destroy generations)
          (make_children generations)
          (mutations generations)
          (setf i (+ i 1)))))
(main)
