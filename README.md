# OSC_x32TC_listener

This is a powershell script desined to be ran along side of James Holts X32TC application http://jamesholt.audio/x32tc/

With this listener running a UDP port is opened on 10024 on all interfaces running as a server. When the OSC (Open Sound Control) command of "/-action/go" is recieved the script will change focus to the x32 applicaion and send the CNTL+g keystroke causing the next cue to run sending it to the x32/m32 system.
