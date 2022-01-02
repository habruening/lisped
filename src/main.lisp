(require :cl-cffi-gtk)

(defpackage lisped
  (:use :cl
   :gtk
   :gobject))

(in-package :lisped)

(defun create-key-button (name icon)
  (let* ((button (make-instance 'gtk-button :width-request 90))
	(box    (make-instance 'gtk-box :orientation :vertical :spacing 4))
	(label  (make-instance 'gtk-label :use-markup t :label name)))
    (gtk-box-pack-start box (gtk-image-new-from-file icon))
    (gtk-box-pack-start box label) 
    (gtk-container-add button box)
    
    button))

(defparameter default-f-key-configs
  (list (cons 'ESC "icons/empty.png")
	(cons 'F1  "icons/help.png")
	(cons 'F2  "icons/menu.svg")
	(cons 'F3  "icons/new_file.svg")
	(cons 'F4  "icons/open_file.svg")
	(cons 'F5  "icons/save_file.svg")
	(cons 'F6  "icons/save_file_as.svg")
	(cons 'F7  "icons/close.svg")
	(cons 'F8  "icons/undo.svg")
	(cons 'F9  "icons/redo.svg")
	(cons 'F10  "icons/copy.svg")
	(cons 'F11  "icons/paste.svg")
	(cons 'F12  "icons/search.svg")))

(defun create-empty-keys ()
  (mapcar (lambda (key-conf)
	    (cons (car key-conf) (create-key-button (string (car key-conf)) (cdr key-conf))))
	    default-f-key-configs))

(defun addkeys (box)
  (dolist (key-button *empty-f-keys*)
    (gtk-box-pack-start box (cdr key-button) :expand nil)))

(defparameter *empty-f-keys* nil)
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
      (setf *f-key-box* (make-instance 'gtk-box
				      :orientation :horizontal
				      :spacing 4))
      (addkeys *f-key-box*)
      (gtk-box-pack-start main-box *f-key-box* :expand nil)
      (gtk-box-pack-start main-box textview)
      (setf *help-overlay* (make-instance 'gtk-overlay))
      (setf *help-test-widget* (make-instance 'gtk-label :label "Hallo"))
      (gtk-container-add *help-overlay* main-box)
      (gtk-container-add window *help-overlay*)
      (let ((fixed (make-instance 'gtk-fixed)))
	(gtk-fixed-put fixed (make-instance 'gtk-label :margin 10 :label "Hallo") 10 10)
	(gtk-overlay-add-overlay *help-overlay* fixed))
      (gtk-widget-show-all window)
      (setf *win* window))))
