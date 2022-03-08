(in-package :help-overlay)

;;; A gtk widget that is overlayed on everything when F1 is pressed.
(defparameter *help-widget* nil)

(defvar *help-overlay-active* nil)

(defun show-help-widget ()
  (gtk-widget-show-now *help-widget*))

(defun setup-help-and-create-overlay-widget ()
  (let ((main-and-help-overlay (make-instance 'gtk-overlay))
        (help-widget (make-instance 'gtk-fixed)))
    (gtk-overlay-add-overlay main-and-help-overlay help-widget)
    (setf *help-overlay-active* t)
    (setf *help-widget* help-widget)
    (setf api:show-help-overlay 'show-help-widget)
    (g-signal-connect main-and-help-widget
                        "button-press-event"
                        (lambda (widget event)
                                (declare (ignore widget event))
                              (print "signal help")))
    main-and-help-overlay))

(defun toggle-help-overlay ()
  (if *help-overlay-active*
    (gtk-widget-hide *help-widget*)
    (gtk-widget-show-now *help-widget*))
  (setf *help-overlay-active* (not *help-overlay-active*)))

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
