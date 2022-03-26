(in-package :lisped)

(defun create-mainwindow ()
  (within-main-loop
    (let ((main-window (make-instance 'gtk-window
                                      :type :toplevel
                                      :title "Lisped Text"
                                      :default-width 700
                                      :default-height 300
                                      :border-width 5))
       	  (main-and-help-overlay (setup-help-and-create-overlay-widget))
       	  (main-widget (make-instance 'gtk-box
                               					  :orientation :vertical
                               					  :spacing 6))
       	  (textview (make-instance 'gtk-text-view
                          				     :wrap-mode :word
                          				     :top-margin 2
                          				     :left-margin 2
                          				     :right-margin 2)))

      (gtk-box-pack-start main-widget (setup-toolbar-and-create-widget) :expand nil)
      (gtk-box-pack-start main-widget textview)
      (gtk-container-add main-and-help-overlay main-widget)
      (gtk-container-add main-window main-and-help-overlay)

      (apply-active-keys)


      (gtk-widget-show-all main-window)

      (apply-active-keys-to-help-overlay)

      (gtk-widget-show-all main-window)
      (toggle-help)


      ;(g-signal-connect main-and-help-overlay
      ;               			"button-press-event"
      ;               			(lambda (widget event)
      ;                     			  (declare (ignore widget event))
      ;                          (print "signal main and help")))
      ;(g-signal-connect main-window
      ;               			"button-press-event"
      ;               			(lambda (widget event)
      ;                     			  (declare (ignore widget event))
      ;                             (print "signal main")))
      ;                     			  (toggle-help-overlay)))
      (gtk-widget-add-events main-window :key-press-mask)
      (gtk-widget-add-events main-window :key-release-mask)
      (let ((help-enabled nil)
            (help-pressed nil))
        (g-signal-connect main-window
                       			"key-press-event"
                       			(lambda (widget event)
                             			  (declare (ignore widget event))
                                  (if (not help-enabled)
                                    (progn (show-help)
                                           (setf help-enabled t)))
                                  (setf help-pressed t))
                       			:after T)

        (g-signal-connect main-window
                       			"key-release-event"
                       			(lambda (widget event)
                             			  (declare (ignore widget event))
                                  (bt:make-thread
                                   (lambda ()
                                           (setf help-pressed nil)
                                           (sleep 0.1)
                                           (if (not help-pressed)
                                             (progn (hide-help)
                                                    (setf help-enabled nil)))
                                           :name "closing help")))
                       			:after T)
        ))))
