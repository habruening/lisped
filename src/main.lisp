(in-package :lisped)

(defun create-key-button (name icon tooltip-text)
  (let ((button (make-instance 'gtk-button :width-request 90 :tooltip-text tooltip-text))
	 (box    (make-instance 'gtk-box :orientation :vertical :spacing 4))
	 (label  (make-instance 'gtk-label :use-markup t :label name)))
    (gtk-box-pack-start box (gtk-image-new-from-file icon))
    (gtk-box-pack-start box label) 
    (gtk-container-add button box)  
    button))

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

(defstruct key-instance button action short-help long-help)

(defun empty-f-keys ()
  (mapcar (lambda (key-name)
	    (cons key-name
		  (make-key-instance :button (create-key-button (string key-name)
								+empty-key-icon+
								"no action")
				     :action nil
				     :short-help "no action"
				     :long-help nil)))
	  +esc-and-f-key-names+))


(defun default-keys ()
  (mapcar (lambda (key-definition)
	    (cons (car key-definition)
		  (make-key-instance :button (create-key-button (string (car key-definition))
								(key-definition-icon-file (cdr key-definition))
								(key-definition-short-help (cdr key-definition)))
				     :action (key-definition-action (cdr key-definition))
				     :short-help (create-short-help-tooltip (key-definition-short-help (cdr key-definition)))
				     :long-help nil)))
	  +esc-and-f-keys-definitions+))

(defparameter *active-keys* nil)

(defun apply-active-keys-to-toolbar (toolbar-box)
  (dolist (key-button *active-keys*)
    (gtk-box-pack-start toolbar-box (key-instance-button (cdr key-button)) :expand nil)))

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
(defparameter *help-widget* nil)

(defun toggle-help-overlay ()
  (if *help-overlay-active*
      (gtk-widget-hide *help-widget*)
      (gtk-widget-show-now *help-widget*))
  (setf *help-overlay-active* (not *help-overlay-active*)))

(defun show-help-widget ()
  (gtk-widget-show-now *help-widget*))

(defun create-mainwindow ()
  (setf *active-keys* (default-keys))
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
	  (apply-active-keys-to-toolbar *f-keys-box*)
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


