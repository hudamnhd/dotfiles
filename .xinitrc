case $( basename "$( tty )" ) in 
    tty1) 
        # Start WM 1 
        exec dwm
        ;; 
    tty2) 
        # Start WM 2 
        exec i3
        ;; 
esac 