//
//  AppDelegate.h
//  MyVstHost
//
//  Created by marvin h on 8/6/16.
//  Copyright © 2016 marvin h. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "pluginterfaces/vst2.x/aeffectx.h"
#include "RtAudio.h"
#include "MidiState.h"
#include "AudioIO.h"


@interface NSView (ViewHierarchyLogging)
- (int)logViewHierarchy;
@end

@interface MyNSView : NSView
{
    @public MidiState *midiState;
}
- (void)keyDown:(NSEvent *)theEvent;
- (void)keyUp:(NSEvent *)theEvent;

@end

@interface WindowDelegate : NSObject <NSWindowDelegate>
{
    NSWindow *window;
}
- (void)setWindow:(NSWindow *)aWindow;

@end
@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    NSWindow *window;
    @public MyNSView *view;
    NSTimer* timer;
    NSWindow *audioAndMidiSettingsWindow;
    WindowDelegate *windowDelegate;
    @public RtAudio *dac;
    @public std::mutex *mtx;
    @public AEffect *effect;
    @public AudioIO *audioIO;
    @public MidiState *midiState;
    @public VstEvents *events;
    
    unsigned int createMenuIndex;
    
}
- (void)createMenu;
- (bool)checkEffectEditor;
@end

