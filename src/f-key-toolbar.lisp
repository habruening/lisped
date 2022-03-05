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
(defstruct key-button-instance button short-help long-help)

(defun make-key-button-instance-with-action (&key button short-help long-help action)
  (g-signal-connect button "clicked"
			(lambda (widget)
			  (declare (ignore widget))
			  (funcall action )))
  (make-key-button-instance :button button :short-help short-help :long-help long-help))

(defun make-key-button-instance-from-definition (key-name key-definition)
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
    (make-key-button-instance :button button-widget :short-help short-help-widget :long-help nil)))

;;; create a list of empty key button instances
(defun create-empty-f-keys ()
  (mapcar (lambda (key-name)
	    (cons key-name
		  (make-key-button-instance-from-definition
		   (string key-name)
		   (make-key-button-definition :icon-file +empty-key-icon+ :short-help "no action" :long-help "undefined"))))
	  +esc-and-f-key-names+))
 
;;; create a list of default key button instances as per definition
(defun create-default-f-keys ()
  (mapcar (lambda (key-definition)
	    (cons (car key-definition)
		  (make-key-button-instance-from-definition
		   (string (car key-definition))
		   (cdr key-definition))))
	  +esc-and-f-keys-definitions+))

(defun create-all-keys ()
  (list (cons 'default-f-keys (create-default-f-keys))
	(cons 'no-keys (create-empty-f-keys))))

(defun apply-active-keys-to-toolbar (toolbar-box)
  (dolist (key-button globals:*active-f-key-buttons*)
    (gtk-box-pack-start toolbar-box (key-button-instance-button (cdr key-button)) :expand nil)))

(defun activate-keys (toolbar-box new-keys)
  (if (eql new-keys nil)
      nil
      (progn (print (car (car new-keys)))
	     (activate-keys toolbar-box (cdr new-keys)))))

(defun clear-toolbar (toolbar-box)
  (let ((buttons-to-be-deleted nil))
    (gtk-container-foreach toolbar-box
			   (lambda (key-button)
			     (setq buttons-to-be-deleted
				   (append buttons-to-be-deleted (list key-button)))))
    buttons-to-be-deleted))
