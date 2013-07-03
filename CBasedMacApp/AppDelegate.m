
#include <objc/runtime.h>
#include <objc/message.h>

extern id NSApp;

struct AppDel
{
    Class isa;
    
    //Will be an NSWindow later, for now, it's id, because we cannot use pointers to ObjC classes
    id window;
};


// This is a strong reference to the class of the AppDelegate
// (same as [AppDelegate class])
Class AppDelClass;

BOOL AppDel_didFinishLaunching(struct AppDel *self, SEL _cmd, id notification) {
    //alloc NSWindow
    self->window = objc_msgSend(objc_getClass("NSWindow"), sel_getUid("alloc"));
    //init NSWindow
    //Adjust frame.  Window would be about 50*50 px without this
    //specify window type.  We want a resizeable window that we can close.
    //use retained backing because this thing is small anyhow
    //return no because this is the main window, and should be shown immediately
    self->window = objc_msgSend(self->window,
                                sel_getUid("initWithContentRect:styleMask:backing:defer:"),(NSRect){0,0,1024,460}, (NSTitledWindowMask|NSClosableWindowMask|NSResizableWindowMask|NSMiniaturizableWindowMask),NSBackingStoreRetained,NO);
    
    //send alloc and init to our view class.  Love the nested objc_msgSends!
    id view = objc_msgSend(objc_msgSend(objc_getClass("View"), sel_getUid("alloc")), sel_getUid("initWithFrame:"), (struct CGRect) { 0, 0, 320, 480 });
    
    // here we simply add the view to the window.
    objc_msgSend(self->window, sel_getUid("setContentView:"), view);
    objc_msgSend(self->window, sel_getUid("becomeFirstResponder"));
    
    //makeKeyOrderFront: NSWindow to show in bottom left corner of the screen
    objc_msgSend(self->window,
                 sel_getUid("makeKeyAndOrderFront:"),
                 self);
    return YES;
}

static void initAppDel()
{
#ifdef TARGET_RT_MAC_MACHO
    //Our appDelegate should be NSObject, but if you want to go the hard route, make this a class pair of NSApplication and try initing those awful delegate methods!
    AppDelClass = objc_allocateClassPair((Class)
                                         objc_getClass("NSObject"), "AppDelegate", 0);
    //Change the implementation of applicationDidFinishLaunching: so we don't have to use ObjC when this is called by the system.
    class_addMethod(AppDelClass,
                    sel_getUid("applicationDidFinishLaunching:"),
                    (IMP) AppDel_didFinishLaunching, "i@:@");
    
    objc_registerClassPair(AppDelClass);
#else
    AppDelClass = class_createInstance(objc_getClass("AppDelegate"), 0);
    
    struct objc_method didFinishLaunchingMethod;
    didFinishLaunchingMethod.method_name = sel_registerName("applicationDidFinishLaunching:");
    didFinishLaunchingMethod.method_imp  = (IMP)AppDel_didFinishLaunching;
    
    struct objc_method_list *appDelMessageList;
    appDelMessageList = malloc (sizeof(struct objc_method_list));
    appDelMessageList->method_count = 1;
    appDelMessageList->method_list[0] = didFinishLaunchingMethod;
    class_addMethods(AppDelClass, appDelMessageList);
#endif
}

static void init_app(void)
{
    objc_msgSend(
                 objc_getClass("NSApplication"),
                 sel_getUid("sharedApplication"));
    
    if (NSApp == NULL)
    {
        fprintf(stderr,"Failed to initialized NSApplication...  terminating...\n");
        return;
    }
    
    id appDelObj = objc_msgSend(
                                objc_getClass("AppDelegate"),
                                sel_getUid("alloc"));
    appDelObj = objc_msgSend(appDelObj, sel_getUid("init"));
    
    objc_msgSend(NSApp, sel_getUid("setDelegate:"), appDelObj);
    objc_msgSend(NSApp, sel_getUid("run"));
}

//there doesn't need to be a main.m because of this little beauty here.
int main(int argc, char** argv)
{
    //Initialize a valid app delegate object just like [NSApplication sharedApplication];
    initAppDel();
    //Initialize the run loop, just like [NSApp run];  this function NEVER returns until the app closes successfully.
    init_app();
    //We should close acceptably.
    return EXIT_SUCCESS;
}