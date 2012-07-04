//
//  ViewController.c
//  CBasediOSApp
//
//  Created by Richard Ross on 4/23/12.
//  Copyright (c) 2012 Ultimate Computer Services, Inc. All rights reserved.
//
#include <objc/runtime.h>
#include <objc/message.h>
#include <ApplicationServices/ApplicationServices.h>
#include <AppKit/AppKit.h>

// This is a strong reference to the class of our custom view,
// In case we need it in the future.
Class ViewClass;


// This is a simple -drawRect implementation for our class. We could have
// used a UILabel  or something of that sort instead, but I felt that this
// stuck with the C-based mentality of the application.
void View_drawRect(id self, SEL _cmd, CGRect rect)
{
    //make a red NSColor object with its convenience method
    id red  = objc_msgSend(objc_getClass("NSColor"), sel_getUid("redColor"));
    
    // fill target rect with red, because this is it!
    NSRect rect1 = NSMakeRect ( 21,21,210,210 );
    objc_msgSend(red, sel_getUid("set"));
    NSRectFill ( rect1 );
}

// Once again we use the (constructor) attribute. generally speaking,
// having many of these is a very bad idea, but in a small application
// like this, it really shouldn't be that big of an issue.
__attribute__((constructor))
static void initView()
{
    
    // Once again, just like the app delegate, we tell the runtime to
    // create a new class, this time a subclass of 'UIView' and named 'View'.
    ViewClass = objc_allocateClassPair((Class) objc_getClass("NSView"), "View", 0);
    
    // and again, we tell the runtime to add a function called -drawRect:
    // to our custom view. Note that there is an error in the type-specification
    // of this method, as I do not know the @encode sequence of 'CGRect' off
    // of the top of my head. As a result, there is a chance that the rect
    // parameter of the method may not get passed properly.
    class_addMethod(ViewClass, sel_getUid("drawRect:"), (IMP) View_drawRect, "v@:");
    
    // And again, we tell the runtime that this class is now valid to be used.
    // At this point, the application should run and display the screenshot shown below.
    objc_registerClassPair(ViewClass);
}