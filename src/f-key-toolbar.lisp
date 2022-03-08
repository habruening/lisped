(in-package :toolbar)

;;; create a key button widget with the given icon and tooltip text
(defun create-key-button-widget (name icon tooltip-text)
  (let ((button (make-instance 'gtk-button :width-request 90 :tooltip-text tooltip-text))
      	 (box    (make-instance 'gtk-box :orientation :vertical :spacing 4))
      	 (label  (make-instance 'gtk-label :use-markup t :label name)))
    (gtk-box-pack-start box (gtk-image-new-from-file icon))
    (gtk-box-pack-start box label)
    (gtk-container-add button box)
    button))

;;; all relevant data of a key button to be able to activate it
(defstruct key-button button short-help long-help)

(defun make-key-button-from-definition (key-name key-definition)
  (let ((button-widget (create-key-button-widget
                     		 key-name
                     		 (key-button-definition-icon-file key-definition)
                     		 (key-button-definition-short-help key-definition)))
       	(short-help-widget (help-overlay:create-short-help-tooltip
                     			    (key-button-definition-short-help key-definition))))
    (if (key-button-definition-action key-definition)
     	(g-signal-connect button-widget "clicked"
                   			  (lambda (widget)
                         			    (declare (ignore widget))
                         			    (funcall (key-button-definition-action key-definition)))))
    (make-key-button :button button-widget :short-help short-help-widget :long-help nil)))

;;; The list of active keys in the f-toolbar. This list is dynamically updated
;;; depending on the actions that are available.
;;; It is an assoc. The keys is intended to be a symbol as identifier. The values are
;;; instances of key-button.
(defparameter *active-f-key-buttons* nil)

(defparameter *available-keys* nil)

;;; create a list of empty key button instances
(defun create-empty-f-keys ()
  (mapcar (lambda (key-name)
             	    (cons key-name
                    		  (make-key-button-from-definition
                    		   (string key-name)
                    		   (make-key-button-definition :icon-file +empty-key-icon+ :short-help "no action" :long-help "undefined"))))
       	  +esc-and-f-key-names+))

;;; create a list of default key button instances as per definition
(defun create-default-f-keys ()
  (mapcar (lambda (key-definition)
             	    (cons (car key-definition)
                    		  (make-key-button-from-definition
                    		   (string (car key-definition))
                    		   (cdr key-definition))))
       	  +esc-and-f-keys-definitions+))

(defun create-all-keys ()
  (list (cons 'default-f-keys (create-default-f-keys))
       	(cons 'no-keys (create-empty-f-keys))))

(defun activate-keys (toolbar-box new-keys)
  (if (eql new-keys nil)
    nil
    (progn (print (car (car new-keys)))
     	     (activate-keys toolbar-box (cdr new-keys)))))


(defparameter *f-keys-box* nil)

(defun setup-toolbar-and-create-widget ()
  (setf *available-keys* (create-all-keys))
  (setf *active-f-key-buttons* (create-default-f-keys))
  (setf *f-keys-box*  (make-instance 'gtk-box
                                  :orientation :horizontal
                                  :spacing 4)))

(defun apply-active-keys ()
  (dolist (key-button *active-f-key-buttons*)
          (gtk-box-pack-start *f-keys-box* (key-button-button (cdr key-button)) :expand nil)))

(defun apply-active-keys-to-help-overlay ()
  (dolist (key-button *active-f-key-buttons*)
          (let* ((widget-allocation (gtk-widget-get-allocation (key-button-button (cdr key-button))))
             	   (widget-allocation-xy (cons (gdk:gdk-rectangle-x widget-allocation)
                                  				       (gdk:gdk-rectangle-y widget-allocation))))
            (print widget-allocation-xy)
            (add-help-widget (key-button-short-help (cdr key-button))
                             widget-allocation-xy))))

(defun clear-toolbar ()
  (let ((buttons-to-be-deleted nil))
    (gtk-container-foreach *f-keys-box*
                     			   (lambda (key-button)
                           			     (setq buttons-to-be-deleted
                                  				   (append buttons-to-be-deleted (list key-button)))))
    buttons-to-be-deleted))
