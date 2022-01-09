(require :cl-cffi-gtk)

(defpackage lisped
  (:use :cl
   :gtk
   :gobject))

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
  (let ((css-provider (make-instance 'gtk-css-provider))b
	(box          (make-instance 'gtk-box))
	(label        (make-instance 'gtk-label :margin 8 :label tooltip-text)))
    (gtk-css-provider-load-from-path css-provider "css.txt")
    (gtk-container-add box label)
    (gtk-style-context-add-provider (gtk-widget-get-style-context box)
				    css-provider
				    +gtk-style-provider-priority-application+)
    box))

(defstruct key-definition icon-file short-help long-help)
(defstruct key-instance   button action short-help long-help)   

(defparameter *esc-and-f-keys-definitions*
  (list (cons 'ESC  (make-key-definition :icon-file "icons/empty.png"        :short-help "" :long-help"" ))
	(cons 'F1   (make-key-definition :icon-file "icons/help.png"         :short-help "help" :long-help"" ))
	(cons 'F2   (make-key-definition :icon-file "icons/menu.svg"         :short-help "menu" :long-help"" ))
	(cons 'F3   (make-key-definition :icon-file "icons/new_file.svg"     :short-help "empty file" :long-help"" ))
	(cons 'F4   (make-key-definition :icon-file "icons/open_file.svg"    :short-help "open file" :long-help"" ))
	(cons 'F5   (make-key-definition :icon-file "icons/save_file.svg"    :short-help "save file" :long-help"" ))
	(cons 'F6   (make-key-definition :icon-file "icons/save_file_as.svg" :short-help "save file as" :long-help"" )) 
 	(cons 'F7   (make-key-definition :icon-file "icons/close.svg"        :short-help "close" :long-help"" ))
	(cons 'F8   (make-key-definition :icon-file "icons/undo.svg"         :short-help "undo" :long-help"" ))
	(cons 'F9   (make-key-definition :icon-file "icons/redo.svg"         :short-help "redo" :long-help"" ))
	(cons 'F10  (make-key-definition :icon-file "icons/copy.svg"         :short-help "copy" :long-help"" ))
	(cons 'F11  (make-key-definition :icon-file "icons/paste.svg"        :short-help "paste" :long-help"" ))
	(cons 'F12  (make-key-definition :icon-file "icons/search.svg"       :short-help "search" :long-help"" ))))

(defun default-keys ()
  (mapcar (lambda (key-definition)
	    (cons (car key-definition)
		  (make-key-instance :button (create-key-button (string (car key-definition)) (key-definition-icon-file (cdr key-definition)) (key-definition-short-help (cdr key-definition)))
				     :action nil 
				     :short-help (create-short-help-tooltip (key-definition-short-help (cdr key-definition)))
				     :long-help nil)))
	  *esc-and-f-keys-definitions*))

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
(defparameter *help-widget* nil)

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
      (setf *win* window))))


