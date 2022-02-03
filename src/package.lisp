(require :cl-cffi-gtk)

(defpackage lisped
  (:use :cl
   :gtk
   :gobject))

(defpackage toolbar
  (:use :cl
         :gtk
	:gobject)
  (:export :create-empty-f-keys
           :create-all-keys
           :apply-active-keys-to-toolbar
   ))
