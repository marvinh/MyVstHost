//
//  AppDelegate.m
//  MyVstHost
//
//  Created by marvin h on 8/6/16.
//  Copyright © 2016 marvin h. All rights reserved.
//

#import "AppDelegate.h"

@interface NSApplication (NiblessAdditions)
-(void) setAppleMenu:(NSMenu *)aMenu;
@end

@implementation NSView (ViewHierarchyLogging)
- (int)logViewHierarchy
{
    int count = 0;
    for (NSView *subview in self.subviews)
    {
        count+=[subview logViewHierarchy]+1;
    }
    return count;
}
@end

@implementation MyNSView

- (void)keyDown:(NSEvent *)theEvent
{
    if(!([theEvent modifierFlags] & NSCommandKeyMask))
    {
        
        
        if ([[theEvent characters] isEqual:@"a"])
        {
            midiState->NoteOn(0);
        }
        else if ([[theEvent characters] isEqual:@"w"])
        {
            midiState->NoteOn(1);
        }
        else if ([[theEvent characters] isEqual:@"s"])
        {
            midiState->NoteOn(2);
        }
        else if ([[theEvent characters] isEqual:@"e"])
        {
            midiState->NoteOn(3);
        }
        else if ([[theEvent characters] isEqual:@"d"])
        {
            midiState->NoteOn(4);
        }
        else if ([[theEvent characters] isEqual:@"f"])
        {
            midiState->NoteOn(5);
        }
        else if ([[theEvent characters] isEqual:@"t"])
        {
            midiState->NoteOn(6);
        }
        else if ([[theEvent characters] isEqual:@"g"])
        {
            midiState->NoteOn(7);
        }
        else if ([[theEvent characters] isEqual:@"y"])
        {
            midiState->NoteOn(8);
        }
        else if ([[theEvent characters] isEqual:@"h"])
        {
            midiState->NoteOn(9);
        }
        else if ([[theEvent characters] isEqual:@"u"])
        {
            midiState->NoteOn(10);
        }
        else if ([[theEvent characters] isEqual:@"j"])
        {
            midiState->NoteOn(11);
        }
        else if ([[theEvent characters] isEqual:@"k"])
        {
            midiState->NoteOn(12);
        }
        else if ([[theEvent characters] isEqual:@"o"])
        {
            midiState->NoteOn(13);
        }
        else if ([[theEvent characters] isEqual:@"l"])
        {
            midiState->NoteOn(14);
        }
        else if([[theEvent characters] isEqual:@"z"])
        {
            midiState->OctaveDown();
            midiState->AllNotesOff();
        }
        else if([[theEvent characters] isEqual:@"x"])
        {
            midiState->OctaveUp();
            midiState->AllNotesOff();
        }
        else if([[theEvent characters] isEqual:@"c"])
        {
            midiState->VelocityDown();
        }
        else if([[theEvent characters] isEqual:@"v"])
        {
            midiState->VelocityUp();
        }
    }
    
}
- (void)keyUp:(NSEvent *)theEvent
{

    if ([[theEvent characters] isEqual:@"a"])
    {
        midiState->NoteOff(0);
        
    }
    else if ([[theEvent characters] isEqual:@"w"])
    {
        midiState->NoteOff(1);
    }
    else if ([[theEvent characters] isEqual:@"s"])
    {
        midiState->NoteOff(2);
    }
    else if ([[theEvent characters] isEqual:@"e"])
    {
        midiState->NoteOff(3);
    }
    else if ([[theEvent characters] isEqual:@"d"])
    {
        midiState->NoteOff(4);
    }
    else if ([[theEvent characters] isEqual:@"f"])
    {
        midiState->NoteOff(5);
    }
    else if ([[theEvent characters] isEqual:@"t"])
    {
        midiState->NoteOff(6);
    }
    else if ([[theEvent characters] isEqual:@"g"])
    {
        midiState->NoteOff(7);
    }
    else if ([[theEvent characters] isEqual:@"y"])
    {
        midiState->NoteOff(8);
    }
    else if ([[theEvent characters] isEqual:@"h"])
    {
        midiState->NoteOff(9);
    }
    else if ([[theEvent characters] isEqual:@"u"])
    {
        midiState->NoteOff(10);
    }
    else if ([[theEvent characters] isEqual:@"j"])
    {
        midiState->NoteOff(11);
    }
    else if ([[theEvent characters] isEqual:@"k"])
    {
        midiState->NoteOff(12);
    }
    else if ([[theEvent characters] isEqual:@"o"])
    {
        midiState->NoteOff(13);
    }
    else if ([[theEvent characters] isEqual:@"l"])
    {
        midiState->NoteOff(14);
    }
}

- (void) flagsChanged:(NSEvent *) event {
    if ([event modifierFlags])
    {
        midiState->AllNotesOff();
    }
}

@end

@implementation WindowDelegate
- (void)windowWillClose:(NSNotification *)notification
{
    [window setIsVisible:(NO)];
}

- (void)windowDidResignKey:(NSNotification *)notification
{
    [window setIsVisible:(NO)];
}

- (void)setWindow:(NSWindow *)aWindow
{
    window = aWindow;
}

@end

@interface AppDelegate ()

@end

@implementation AppDelegate
- (id)init
{
    if(self = [super init])
    {
        
        view = [[MyNSView alloc] initWithFrame:CGRectMake(0, 0, 480, 300)];
        NSUInteger windowStyleMask = NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask;
        window  = [[NSWindow alloc] initWithContentRect:CGRectMake(0, 0, 480, 300)
                                              styleMask:windowStyleMask
                                                backing:NSBackingStoreBuffered
                                                  defer:YES];
        [window makeKeyAndOrderFront:NSApp];
        [window center];
        [window makeFirstResponder:view];
        [window makeMainWindow];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0/30 target:self selector:@selector(update) userInfo:nil repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        [self createMenu];
        
        audioAndMidiSettingsWindow  = [[NSWindow alloc] initWithContentRect:CGRectMake(0, 0, 300, 400)
                                                                  styleMask:windowStyleMask
                                                                    backing:NSBackingStoreBuffered
                                                                      defer:YES];
        windowDelegate = [[WindowDelegate alloc] init];
        
        [audioAndMidiSettingsWindow setDelegate:(windowDelegate)];
        [audioAndMidiSettingsWindow setReleasedWhenClosed:(false)];
        
        [windowDelegate setWindow:(audioAndMidiSettingsWindow)];
        
        
    }
    return self;
}
- (void)createMenu
{
    NSString *appName = @"MyVstHost";
    NSMenu* mainMenu = [[NSMenu alloc] initWithTitle: @"MainMenu"];
    NSMenuItem* item = [mainMenu addItemWithTitle: @"Apple" action: nil keyEquivalent: @""];
    
    NSMenu* appMenu = [[NSMenu alloc] initWithTitle: @"Apple"];
    
    [NSApp performSelector: @selector (setAppleMenu:) withObject: appMenu];
    [mainMenu setSubmenu: appMenu forItem: item];
    [NSApp setMainMenu: mainMenu];
    
    // Services...
    NSMenuItem* services = [[NSMenuItem alloc] initWithTitle: @"Services"
                                                      action: nil
                                               keyEquivalent: @""];
    [appMenu addItem: services];
    
    NSMenu* servicesMenu = [[NSMenu alloc] initWithTitle: @"Services"];
    [appMenu setSubmenu: servicesMenu forItem: services];
    [NSApp setServicesMenu: servicesMenu];
    [appMenu addItem: [NSMenuItem separatorItem]];
    
    
    [appMenu addItemWithTitle:[@"Hide " stringByAppendingString:appName]
                       action:@selector(hide:)
                keyEquivalent:@"h"];
    
    item = [[NSMenuItem alloc] initWithTitle: @"Hide Others"
                                      action:@selector(hideOtherApplications:)
                               keyEquivalent:@"h"];
    [item setKeyEquivalentModifierMask: NSCommandKeyMask | NSAlternateKeyMask];
    [appMenu addItem:item];
    
    [appMenu addItemWithTitle:@"Show All"
                       action:@selector (unhideAllApplications:)
                keyEquivalent:@""];
    
    [appMenu addItem: [NSMenuItem separatorItem]];
    
    [appMenu addItemWithTitle:[@"Quit " stringByAppendingString:appName]
                       action:@selector (terminate:)
                keyEquivalent:@"q"];
    
    item = [mainMenu addItemWithTitle: @"Options" action: nil keyEquivalent: @""];
    
    appMenu = [[NSMenu alloc] initWithTitle: @"Options"];
    
    [mainMenu setSubmenu: appMenu forItem: item];
    
    NSMenuItem *audioAndMidiSettingsMenuItem =  [[NSMenuItem alloc]initWithTitle: @"Audio and Midi Settings"
                                                                          action:@selector(showAudioAndMidiSettingsWindow)
                                                                   keyEquivalent:@"a"];
    
    [appMenu addItem:(audioAndMidiSettingsMenuItem)];
}

- (void)showAudioAndMidiSettingsWindow
{
    [audioAndMidiSettingsWindow center];
    [audioAndMidiSettingsWindow setIsVisible:(YES)];
}


- (void)windowShouldClose:(NSNotification *)notification {
    NSLog(@"YOO");
    
}

- (void)update
{

    effect->dispatcher (effect, effEditIdle, 0, 0, 0, 0);
    [self handleComputerMidiKeyboard];
}

- (void)handleComputerMidiKeyboard
{
    int hasVstPopUpMenuBeenClicked = [view logViewHierarchy];
    if(hasVstPopUpMenuBeenClicked == 2)
    {
        midiState->AllNotesOff();
    }
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuClicked:) name:
     NSMenuDidBeginTrackingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow) name:NSWindowDidResignKeyNotification object:audioAndMidiSettingsWindow];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow) name:NSWindowDidResignMainNotification object:audioAndMidiSettingsWindow];
    
}
- (void)closeWindow
{
    [audioAndMidiSettingsWindow close];
    [NSApp stopModal];
}
- (void)menuClicked : (NSNotification *)inSender
{
    midiState->AllNotesOff();
}
- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    //Clean Up
    try
    {
        // Stop the stream
        dac->stopStream();
    }
    catch (RtAudioError& e)
    {
        e.printMessage();
    }
    
    if ( dac->isStreamOpen() ) dac->closeStream();
    
    if (effect)
    {
        printf ("HOST> Close editor..\n");
        effect->dispatcher (effect, effEditClose, 0, 0, 0, 0);
        printf ("HOST> Close effect...\n");
        effect->dispatcher (effect, effClose, 0, 0, 0, 0);
    }
    
    delete dac;
    delete events;
    delete midiState;
    delete audioIO;
    delete mtx;
    
    [timer invalidate];
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    
    return YES;
}

- (bool) checkEffectEditor
{
    if ((effect->flags & effFlagsHasEditor) == 0)
    {
        printf ("This plug does not have an editor!\n");
        return false;
    }
    
    
    ERect* eRect = 0;
    printf ("HOST> Get editor rect..\n");
    effect->dispatcher (effect, effEditGetRect, 0, 0, &eRect, 0);
    printf ("HOST> Open editor...\n");
    effect->dispatcher(effect,effEditOpen,0,0,(__bridge void *)view,0.0f);
    
    printf ("HOST> Get editor rect..\n");
    effect->dispatcher (effect, effEditGetRect, 0, 0, &eRect, 0);
    effect->dispatcher (effect, effGetProgram, 0, 0, 0, 0);
    
    if (eRect)
    {
        int width = eRect->right - eRect->left;
        int height = eRect->bottom - eRect->top + 20;
        NSRect frame = CGRectMake(0, 0, width, height);
        [view setFrame:frame];
        [window setFrame:frame display:YES];
        [window center];
    }
    
    [window.contentView addSubview:view];
    
    return true;
}
@end
