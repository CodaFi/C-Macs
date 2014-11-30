## C-Macs
### A Cocoa Application with no Nibs and no Objective-C Code

C-Macs is a successful attempt to port the ability to [dig a foundation with a spoon](http://stackoverflow.com/questions/10289890/how-to-write-ios-app-purely-in-c#comment13239523_10289913).  The app is written entirely in C, with gratuitous calls to the Objective-C Runtime.  

## Features
* Nibless!
* Main.m-less!
* Cocoa-less!
* Uses under 1.5 MB of memory at any one time (most of it is used for drawing the window).
* A red square in the lower-left-hand corner (drawn in Core Graphics).

## License
* Absolutely no license.  Use it at your own risk, and don't blame me if anything bad happens.  Oh, and if you extend it, make sure there isn't any Objective-C in it!

##Important Notes & Bugs
* The app does not release allocated memory;
* There is an implied autoreleasepool, but one is not explicitly created.
* A small reliance on `__attribute__((constructor))`, which is not the best way to do things…
* WAY too many framework includes and links to dylibs we don't need.
* Built and tested on OS X Lion.  Theoretically, it's possible this works on all machines that support the modern ObjC runtime, however, use on older OSes below 10.6 is highly discouraged.
* All calls to framework objects are compliant with OS X 10.0+, however the code will only run on intel architectures.  This will be remedied first.