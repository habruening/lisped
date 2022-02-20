(in-package :globals)

;;; The list of active keys in the f-toolbar. This list is dynamically updated
;;; depending on the actions that are available.
;;; It is an assoc. The keys is intended to be a symbol as identifier. The values are
;;; instances of key-button. 
(defparameter *active-f-key-buttons* nil)

;;; A gtk widget that is overlayed when F1 is pressed.
(defparameter *help-widget* nil)

;;; This is the definition format that is used to define the standard behaviour
;;; of the toolbar
(defstruct key-button-definition
  icon-file   ; the path of the icon
  short-help  ; a short help message that is displayed in the F1 help
  long-help   ; a longer help text that explains more details
  action      ; the function that shall be executed when the key-button is pressed
  )
