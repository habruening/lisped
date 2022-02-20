(in-package :toolbar)

;;; The names of the keys in f-key-toolbar
(defconstant +esc-and-f-key-names+ '(ESC F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12))

;;; The icon for keys that are not active
(defconstant +empty-key-icon+ "icons/empty.png")

;;; The default configuration of the f-key-toolbar
(defconstant +esc-and-f-keys-definitions+
  (list (cons 'ESC  (make-key-button-definition :icon-file "icons/empty.png"
						:short-help "" :long-help""
						:action nil))
	(cons 'F1   (make-key-button-definition :icon-file "icons/help.png"
						:short-help "help" :long-help""
						:action (lambda ()
							  (gtk-widget-show-now globals:*help-widget*))))
	(cons 'F2   (make-key-button-definition :icon-file "icons/menu.svg"
	      					:short-help "menu" :long-help""
						:action nil))
	(cons 'F3   (make-key-button-definition :icon-file "icons/new_file.svg"
						:short-help "empty file" :long-help""
						:action nil))
	(cons 'F4   (make-key-button-definition :icon-file "icons/open_file.svg"
						:short-help "open file" :long-help""
						:action nil))
	(cons 'F5   (make-key-button-definition :icon-file "icons/save_file.svg"
						:short-help "save file" :long-help""
						:action nil))
	(cons 'F6   (make-key-button-definition :icon-file "icons/save_file_as.svg"
						:short-help "save file as" :long-help""
						:action nil)) 
 	(cons 'F7   (make-key-button-definition :icon-file "icons/close.svg"
						:short-help "close" :long-help""
						:action nil))
	(cons 'F8   (make-key-button-definition :icon-file "icons/undo.svg"
						:short-help "undo" :long-help""
						:action nil))
	(cons 'F9   (make-key-button-definition :icon-file "icons/redo.svg"
						:short-help "redo" :long-help""
						:action nil))
	(cons 'F10  (make-key-button-definition :icon-file "icons/copy.svg"
						:short-help "copy" :long-help""
						:action nil))
	(cons 'F11  (make-key-button-definition :icon-file "icons/paste.svg"
						:short-help "paste" :long-help""
						:action nil))
	(cons 'F12  (make-key-button-definition :icon-file "icons/search.svg"
						:short-help "search" :long-help""
						:action nil))))
