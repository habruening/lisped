(require :cl-cffi-gtk)

(defpackage api
  (:use :cl)
  (:export :*main-window*
           :show-help-overlay
       	   :key-button-definition
           :make-key-button-definition
       	   :key-button-definition-icon-file
           :key-button-definition-short-help
       	   :key-button-definition-action))

(defpackage help-overlay
  (:use :cl :gtk :gobject)
  (:export :create-short-help-tooltip
           :setup-help-and-create-overlay-widget
           :toggle-help-overlay
           :add-help-widget))

(defpackage toolbar
  (:use :cl :gtk :gobject :api :help-overlay)
  (:export  :+esc-and-f-key-names+
            :apply-active-keys
            :apply-active-keys-to-help-overlay
            :setup-toolbar-and-create-widget
            ))


(defpackage lisped
  (:use :cl :gtk :gobject :api :toolbar :help-overlay))
