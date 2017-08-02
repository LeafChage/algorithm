(defconstant +count+ 50)
(defconstant +live+ "o ")
(defconstant +death+ "_ ")

(defvar *pioneers* (/ (* +count+ +count+) 4))

(defclass field ()
  ((cells
     :accessor cells)))

;初期化
(defmethod init ((f field))
  (setf (cells f) (make-array (list +count+ +count+) :initial-element +death+)))

;randomに最初の生物を入れる
(defmethod random-birthday ((f field))
  (loop for i from 0 to *pioneers*
       do
       (setf (aref (cells f) (random +count+) (random +count+)) +live+)))

;そのセルは生きているか確認
(defmethod is_exists ((f field) x y)
  (let ((result nil))
      (when (equal (aref (cells f) x  y) +live+)
        (setf result t))
      result))


;周辺8セルを調べて合計値を返す
(defmethod get-neighbors-count ((f field) x y)
  (let ((result 0))
    (when (and (>= (- x 1) 0) (>= (- y 1) 0)
               (is_exists f (- x 1) (- y 1))) (incf result))
    (when (and (>= (- y 1) 0)
               (is_exists f x (- y 1)))  (incf result))
    (when (and (< (+ x 1) +count+) (>= (- y 1) 0)
               (is_exists f (+ x 1) (- y 1))) (incf result))
    (when (and (>= (- x 1) 0)
               (is_exists f (- x 1) y)) (incf result))
    (when (and (< (+ x 1) +count+)
               (is_exists f (+ x 1) y)) (incf result))
    (when (and (>= (- x 1) 0) (< (+ y 1) +count+)
               (is_exists f (- x 1) (+ y 1))) (incf result))
    (when (and (< (+ y 1) +count+)
               (is_exists f x (+ y 1)))  (incf result))
    (when (and
            (< (+ x 1) +count+) (< (+ y 1) +count+)
               (is_exists f (+ x 1) (+ y 1))  (incf result)))
    result ))

;生きるか死ぬかを決める
(defmethod decide-life ((f field) x y)
  (let ((neighbor-count (get-neighbors-count f x y)))
    (if (is_exists f x y)
      (cond ((or (= neighbor-count 0) (= neighbor-count 1)) (death-cell f x y)) ;過疎死
            ; ((or (= neighbor-count 2) (= neighbor-count 3)) ()) ;何もしない
            ((>= neighbor-count 4) (death-cell f x y))) ;過密死
      (when (= neighbor-count 3) (live-cell f x y))))) ;生殖、誕生

;セルに生物を発生させる
(defmethod live-cell ((f field) x y)
  (setf (aref (cells f) x y) +live+))

;せるの生物を殺す
(defmethod death-cell ((f field) x y)
  (setf (aref (cells f) x y) +death+))

;fieldの描画
(defmethod write-field ((f field))
  (loop for x from 0 to (- +count+ 1)
        do
        (loop for y from 0 to (- +count+ 1)
              do
              (princ (aref (cells f) x y)))
        (fresh-line))
  (terpri))

(defun main ()
     (let ((field (make-instance 'field)))
       (labels ((lifetime (field)
                          (loop for x from 0 to (- +count+ 1)
                                do
                                (loop for y from 0 to (- +count+ 1)
                                      do
                                      (decide-life field x y)))))
         (init field)
         (random-birthday field)
         (write-field field)
         (loop for i from 0 to 500
               do
               (lifetime field)
               (write-field field)
               (sleep 0.05)))))

(main)
