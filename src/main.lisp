(require :cl-cffi-gtk)

(defpackage lisped
  (:use :cl
   :gtk
   :gobject))

(in-package :lisped)

(defun create-key-button (name icon)
  (let ((button (make-instance 'gtk-button :width-request 90))
	 (box    (make-instance 'gtk-box :orientation :vertical :spacing 4))
	 (label  (make-instance 'gtk-label :use-markup t :label name)))
    (gtk-box-pack-start box (gtk-image-new-from-file icon))
    (gtk-box-pack-start box label) 
    (gtk-container-add button box)  
    button))

(defun create-short-help-tooltip (text)
  (let ((css-provider (make-instance 'gtk-css-provider))
	(box          (make-instance 'gtk-box))
	(label        (make-instance 'gtk-label :margin 5 :label text)))
    (gtk-css-provider-load-from-path css-provider "css.txt")
    (gtk-container-add box label)
    (gtk-style-context-add-provider (gtk-widget-get-style-context box)
				    css-provider
				    +gtk-style-provider-priority-application+)
    box)
  )

(defstruct key-definition icon-file short-help long-help)
(defstruct key-instance   button action short-help long-help)   

(defparameter *esc-and-f-keys-definitions*
  (list (cons 'ESC  (make-key-definition :icon-file "icons/empty.png"        :short-help "" :long-help"" ))
	(cons 'F1   (make-key-definition :icon-file "icons/help.png"         :short-help "help" :long-help"" ))
	(cons 'F2   (make-key-definition :icon-file "icons/menu.svg"         :short-help "menu" :long-help"" ))
	(cons 'F3   (make-key-definition :icon-file "icons/new_file.svg"     :short-help "" :long-help"" ))
	(cons 'F4   (make-key-definition :icon-file "icons/open_file.svg"    :short-help "" :long-help"" ))
	(cons 'F5   (make-key-definition :icon-file "icons/save_file.svg"    :short-help "" :long-help"" ))
	(cons 'F6   (make-key-definition :icon-file "icons/save_file_as.svg" :short-help "" :long-help"" )) 
 	(cons 'F7   (make-key-definition :icon-file "icons/close.svg"        :short-help "" :long-help"" ))
	(cons 'F8   (make-key-definition :icon-file "icons/undo.svg"         :short-help "" :long-help"" ))
	(cons 'F9   (make-key-definition :icon-file "icons/redo.svg"         :short-help "" :long-help"" ))
	(cons 'F10  (make-key-definition :icon-file "icons/copy.svg"         :short-help "" :long-help"" ))
	(cons 'F11  (make-key-definition :icon-file "icons/paste.svg"        :short-help "" :long-help"" ))
	(cons 'F12  (make-key-definition :icon-file "icons/search.svg"       :short-help "" :long-help"" ))))

(defun create-empty-keys ()
  (mapcar (lambda (key-definition)
	    (cons (car key-definition)
		  (make-key-instance :button (create-key-button (string (car key-definition)) (key-definition-icon-file (cdr key-definition)))
				     :action nil 
				     :short-help (create-short-help-tooltip (key-definition-short-help (cdr key-definition)))
				     :long-help nil)))
	  *esc-and-f-keys-definitions*))

(defparameter *empty-f-keys* nil)

(defun addkeys (f-key-box)
  (dolist (key-button *empty-f-keys*)
    (gtk-box-pack-start f-key-box (key-instance-button (cdr key-button)) :expand nil)))

(defun addhelps (help-overlay)
  (let ((x 10))
    (dolist (key-button *empty-f-keys*)
      (print x)
      (setf x (+ x 30))
      (gtk-fixed-put help-overlay (key-instance-short-help (cdr key-button)) x 20))))

(defparameter *f-keys-box* nil)
(defparameter *win* nil)
(defparameter *help-overlay* nil)
(defparameter *help-test-widget* nil)

(defun create-mainwindow ()
  (setf *empty-f-keys* (create-empty-keys))
  (within-main-loop
    (let ((window (make-instance 'gtk-window
                                 :type :toplevel
                                 :title "Lisped Text"
                                 :default-width 700
                                 :default-height 300
                                 :border-width 5))
          (main-box (make-instance 'gtk-box
                              :orientation :vertical
                              :spacing 6))
	  (textview (make-instance 'gtk-text-view
                                   :wrap-mode :word
                                   :top-margin 2
                                   :left-margin 2
                                   :right-margin 2)))
      (setf *f-keys-box* (make-instance 'gtk-box
				      :orientation :horizontal
				      :spacing 4))
      (addkeys *f-keys-box*)
      (gtk-box-pack-start main-box *f-keys-box* :expand nil)
      (gtk-box-pack-start main-box textview)
      (setf *help-overlay* (make-instance 'gtk-overlay))
      (gtk-container-add *help-overlay* main-box)
      (gtk-container-add window *help-overlay*)
      (let ((fixed (make-instance 'gtk-fixed)))
	(addhelps fixed)
	(gtk-overlay-add-overlay *help-overlay* fixed))
      (gtk-widget-show-all window)
      (setf *win* window))))
