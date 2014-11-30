
#include <stdlib.h>
#include <stdio.h>
#include "CMacsTypes.h"

/// A reference to NSApp.  Always a good idea, seeing has he's probably the most helpful thing in CocoaLand
extern id NSApp;

/// This is a strong reference to the class of the AppDelegate
/// (same as [AppDelegate class])
Class AppDelClass;

BOOL AppDel_didFinishLaunching(AppDelegate *self, SEL _cmd, id notification) {
	self->window = cmacs_simple_msgSend((id)objc_getClass("NSWindow"), sel_getUid("alloc"));
	
	/// Create an instance of the window.
	self->window = cmacs_window_init_msgSend(self->window, sel_getUid("initWithContentRect:styleMask:backing:defer:"), (CMRect){0,0,1024,460}, (NSTitledWindowMask | NSClosableWindowMask | NSResizableWindowMask | NSMiniaturizableWindowMask), 0, false);
	
	/// Create an instance of our view class.
	///
	/// Relies on the view having declared a constructor that allocates a class pair for it.
	id view = cmacs_rect_msgSend1(cmacs_simple_msgSend((id)objc_getClass("View"), sel_getUid("alloc")), sel_getUid("initWithFrame:"), (CMRect){ 0, 0, 320, 480 });
	
	// here we simply add the view to the window.
	cmacs_void_msgSend1(self->window, sel_getUid("setContentView:"), view);
	cmacs_simple_msgSend(self->window, sel_getUid("becomeFirstResponder"));
	
	// Shows our window in the bottom-left hand corner of the screen.
	cmacs_void_msgSend1(self->window, sel_getUid("makeKeyAndOrderFront:"), self);
	return YES;
}

static void CreateAppDelegate() {
	AppDelClass = objc_allocateClassPair((Class)objc_getClass("NSObject"), "AppDelegate", 0);
	class_addMethod(AppDelClass, sel_getUid("applicationDidFinishLaunching:"), (IMP)AppDel_didFinishLaunching, "i@:@");
	objc_registerClassPair(AppDelClass);
}

void RunApplication(void) {
	cmacs_simple_msgSend((id)objc_getClass("NSApplication"), sel_getUid("sharedApplication"));
	
	if (NSApp == NULL) {
		fprintf(stderr,"Failed to initialized NSApplication...  terminating...\n");
		return;
	}
	
	id appDelObj = cmacs_simple_msgSend((id)objc_getClass("AppDelegate"), sel_getUid("alloc"));
	appDelObj = cmacs_simple_msgSend(appDelObj, sel_getUid("init"));
	
	cmacs_void_msgSend1(NSApp, sel_getUid("setDelegate:"), appDelObj);
	cmacs_void_msgSend(NSApp, sel_getUid("run"));
}

int main(int argc, char ** argv) {
	CreateAppDelegate();
	RunApplication();
	return EXIT_SUCCESS;
}