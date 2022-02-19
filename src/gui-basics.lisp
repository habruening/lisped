(in-package :gui-basics)

(defun create-short-help-tooltip (tooltip-text)
  (let ((css-provider (make-instance 'gtk-css-provider))
	(box          (make-instance 'gtk-box))
	(label        (make-instance 'gtk-label :margin 8 :label tooltip-text)))
    (gtk-css-provider-load-from-path css-provider "css.txt")
    (gtk-container-add box label)
    (gtk-style-context-add-provider (gtk-widget-get-style-context box)
				    css-provider
				    +gtk-style-provider-priority-application+)
    box))
