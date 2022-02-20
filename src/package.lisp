(require :cl-cffi-gtk)

(defpackage globals
  (:use :cl)
  (:export :*help-widget* :*active-f-key-buttons*
	   :key-button-definition
   :make-key-button-definition
	   :key-button-definition-icon-file
   :key-button-definition-short-help
	   :key-button-definition-action))

(defpackage help-overlay
  (:use :cl :gtk :gobject)
  (:export :create-short-help-tooltip))

(defpackage toolbar
  (:use :cl :gtk :gobject :globals)
  (:export  :+esc-and-f-key-names+
   :create-empty-f-keys
	    :create-default-f-keys
   :create-all-keys
	    :apply-active-keys-to-toolbar
   :key-button-instance-button
	    :key-button-instance-short-help))

(defpackage lisped
  (:use :cl :gtk :gobject :globals :toolbar))
