(in-package :lisped)


(defstruct key-instance button action short-help long-help)

(defparameter *available-keys* nil)

(defun apply-active-keys-to-help-overlay (help-overlay)
  (dolist (key-button *active-keys*)
    (let* ((widget-allocation (gtk-widget-get-allocation (key-instance-button (cdr key-button))))
	   (widget-allocation-xy (cons (gdk:gdk-rectangle-x widget-allocation)
				       (gdk:gdk-rectangle-y widget-allocation))))
      (print widget-allocation-xy)
      (gtk-fixed-put help-overlay (key-instance-short-help (cdr key-button))
		     (car widget-allocation-xy) (cdr widget-allocation-xy)))))

(defparameter *f-keys-box* nil)
(defparameter *win* nil)
(defparameter *help-overlay* nil)
(defvar *help-overlay-active* nil)

(defun toggle-help-overlay ()
  (if *help-overlay-active*
      (gtk-widget-hide *help-widget*)
      (gtk-widget-show-now *help-widget*))
  (setf *help-overlay-active* (not *help-overlay-active*)))

(defun show-help-widget ()
  (gtk-widget-show-now *help-widget*))

(defun create-mainwindow ()
  (setf *available-keys* (toolbar:create-all-keys)) 
  (setf *active-keys* (toolbar:create-empty-f-keys))
  (within-main-loop
    (let ((window (make-instance 'gtk-window
                                 :type :toplevel
                                 :title "Lisped Text"
                                 :default-width 700
                                 :default-height 300
                                 :border-width 5)))
      (let ((main-and-help-overlay (make-instance 'gtk-overlay)))
	(let ((main-widget (make-instance 'gtk-box
					  :orientation :vertical
					  :spacing 6)))
	  (setf *f-keys-box* (make-instance 'gtk-box
					    :orientation :horizontal
					    :spacing 4))
	  (toolbar:apply-active-keys-to-toolbar *f-keys-box*)
	  (gtk-box-pack-start main-widget *f-keys-box* :expand nil)
	  (let ((textview (make-instance 'gtk-text-view
					  :wrap-mode :word
					  :top-margin 2
					  :left-margin 2
					  :right-margin 2)))
	    (gtk-box-pack-start main-widget textview))
	  (gtk-container-add main-and-help-overlay main-widget))
	(setf *help-widget* (make-instance 'gtk-fixed))
	(gtk-container-add window main-and-help-overlay)
	(gtk-overlay-add-overlay main-and-help-overlay *help-widget*))
      (gtk-widget-show-all window)
      (apply-active-keys-to-help-overlay *help-widget*)
      (gtk-widget-show-all window)
      (gtk-widget-hide *help-widget*)
      (g-signal-connect (key-instance-button
			 (cdr (assoc 'F1 *active-keys*))) "clicked"
			 (lambda (widget)
			   (declare (ignore widget))
			   (gtk-widget-show-now *help-widget*)))
      (g-signal-connect window
			"button-press-event"
			(lambda (widget event)
			  (declare (ignore widget event))
			  (gtk-widget-hide *help-widget*)))
      (setf *win* window)
      (gtk-widget-add-events window :key-press-mask)
      (g-signal-connect window
			"key-press-event"
			(lambda (widget event)
			  (declare (ignore widget event))
			  (toggle-help-overlay))
			:after T))))


