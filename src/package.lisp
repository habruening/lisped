(require :cl-cffi-gtk)

(defpackage globals
  (:use :cl)
  (:export :*help-widget*
   :*active-keys*
	   :key-definition
	   :make-key-definition
   ))

(defpackage gui-basics
  (:use :cl
        :gtk
	:gobject)
  (:export :create-short-help-tooltip))

(defpackage lisped
  (:use :cl
   :gtk
   :gobject))

(defpackage toolbar
  (:use :cl
        :gtk
	:gobject
	:globals)
  (:export :create-empty-f-keys
           :create-all-keys
           :apply-active-keys-to-toolbar
   ))
