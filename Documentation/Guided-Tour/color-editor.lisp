(eval-when (:compile-toplevel :load-toplevel :execute)
  (asdf:oos 'asdf:load-op :clim)
  (asdf:oos 'asdf:load-op :clim-clx))

(in-package :clim-user)

(defun make-color-slider (id initval label)
  (labelling (:label label)
    (make-pane ':slider :id id :orientation :horizontal :value initval
	       :max-value 1 :min-value 0
	       :drag-callback #'color-slider-dragged
	       :value-changed-callback #'color-slider-value-changed)))

(define-application-frame color-editor ()
  (current-color-pane
   drag-feedback-pane
   (red :initform 0.0)
   (green :initform 1.0)
   (blue :initform 0.0))
  (:pane (with-slots (drag-feedback-pane current-color-pane red green blue)
	     *application-frame*
	   (vertically ()
	     (setf current-color-pane
		   (make-pane 'application-pane :min-height 100 :max-height 100
			 :background (make-rgb-color red green blue)))
	     (horizontally (:min-height 200 :max-height 200)
	       (1/2 (make-color-slider 'red red "Red"))
	       (1/4 (make-color-slider 'green green "Green"))
	       (1/4 (make-color-slider 'blue blue "Blue")))
	     +fill+
	     (setf drag-feedback-pane
		   (make-pane 'application-pane :min-height 100 :max-height 100
			      :background (make-rgb-color red green blue))))))
  (:menu-bar t))

(defun color-slider-dragged (slider value)
  (with-slots (drag-feedback-pane red green blue) *application-frame*
    (setf (medium-background drag-feedback-pane)
	  (ecase (gadget-id slider)
	    (red (make-rgb-color value green blue))
	    (green (make-rgb-color red value blue))
	    (blue (make-rgb-color red green value))))
    (redisplay-frame-pane *application-frame* drag-feedback-pane)))

(defun color-slider-value-changed (slider new-value)
  (with-slots (current-color-pane red green blue) *application-frame*
    ;; The gadget-id symbols match the slot names in color-editor
    (setf (slot-value *application-frame* (gadget-id slider)) new-value)
    (setf (medium-background current-color-pane)
	  (make-rgb-color red green blue))
    (redisplay-frame-pane *application-frame* current-color-pane)))

(define-color-editor-command (com-quit :name "Quit" :menu t) ()
  (frame-exit *application-frame*))
