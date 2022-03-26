(in-package :help-overlay)

;;; A gtk widget that is overlayed on everything when F1 is pressed.
(defparameter *help-widget* nil)

(defparameter *help-overlay* nil)

(defvar *help-overlay-active* nil)

(defun show-help ()
  (setf *help-overlay-active* t)
  (gtk-widget-show-now *help-widget*))

(defun hide-help ()
  (setf *help-overlay-active* nil)
  (gtk-widget-hide *help-widget*))


(defun toggle-help ()
  (if *help-overlay-active*
    (gtk-widget-hide *help-widget*)
    (gtk-widget-show-now *help-widget*))
  (setf *help-overlay-active* (not *help-overlay-active*)))

(defun setup-help-and-create-overlay-widget ()
  (let ((main-and-help-overlay (make-instance 'gtk-overlay))
        (help-widget (make-instance 'gtk-fixed)))
    (gtk-widget-set-has-window help-widget t) ; otherwise it does not receive mouse click
    (gtk-overlay-add-overlay main-and-help-overlay help-widget)
    (setf *help-overlay-active* t)
    (setf *help-widget* help-widget)
    (setf *help-overlay* main-and-help-overlay)
    (setf api:show-help-overlay 'show-help)
    (g-signal-connect *help-widget*
                        "button-press-event"
                        (lambda (widget event)
                                (declare (ignore widget event))
                              (toggle-help)))
    main-and-help-overlay))

;;; create a short help tooltip widget that can be used on the help overlay
(defun create-short-help-tooltip (tooltip-text)
  (let ((css-provider (make-instance 'gtk-css-provider))
       	(box          (make-instance 'gtk-box))
       	(label        (make-instance 'gtk-label :margin 8 :label tooltip-text)))
    (gtk-css-provider-load-from-path css-provider "css.txt")
    (gtk-container-add box label)
    (gtk-style-context-add-provider (gtk-widget-get-style-context box)
                            				    css-provider
                            				    +gtk-style-provider-priority-application+)
    box))

(defun add-help-widget (help-widget position-xy)
  (gtk-fixed-put *help-widget*
                 help-widget
                 (car position-xy) (cdr position-xy)))
