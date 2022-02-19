(in-package :toolbar)

(defun create-key-button (name icon tooltip-text)
  (let ((button (make-instance 'gtk-button :width-request 90 :tooltip-text tooltip-text))
	 (box    (make-instance 'gtk-box :orientation :vertical :spacing 4))
	 (label  (make-instance 'gtk-label :use-markup t :label name)))
    (gtk-box-pack-start box (gtk-image-new-from-file icon))
    (gtk-box-pack-start box label) 
    (gtk-container-add button box)  
    button))

(defstruct key-instance button action short-help long-help)

(defun create-empty-f-keys ()
  (mapcar (lambda (key-name)
	    (cons key-name
		  (make-key-instance :button (create-key-button (string key-name)
								+empty-key-icon+
								"no action")
				     :action nil
				     :short-help (gui-basics:create-short-help-tooltip "undefined")
				     :long-help nil)))
	  +esc-and-f-key-names+))

(defun create-default-keys ()
  (mapcar (lambda (key-definition)
	    (cons (car key-definition)
		  (make-key-instance :button (create-key-button (string (car key-definition))
								(key-definition-icon-file (cdr key-definition))
								(key-definition-short-help (cdr key-definition)))
				     :action (key-definition-action (cdr key-definition))
				     :short-help (gui-basics:create-short-help-tooltip (key-definition-short-help (cdr key-definition)))
				     :long-help nil)))
	  +esc-and-f-keys-definitions+))


(defun create-all-keys ()
  (list (cons 'default-keys (create-default-keys))
	(cons 'no-keys (create-empty-f-keys))))

(defun apply-active-keys-to-toolbar (toolbar-box)
  (dolist (key-button globals:*active-keys*)
    (gtk-box-pack-start toolbar-box (key-instance-button (cdr key-button)) :expand nil)))

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
