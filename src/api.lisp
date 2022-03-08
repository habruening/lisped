(in-package :api)

;;; The main window
(defparameter *main-window* nil)

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
