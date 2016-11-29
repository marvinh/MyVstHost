//
//  main.m
//  MyVstHost
//
//  Created by marvin h on 8/6/16.
//  Copyright © 2016 marvin h. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "AppDelegate.h"
#include "PluginFunctions.h"

int main(int argc, const char * argv[])
{
    // Insert code here to initialize your application
    
    RtAudio *dac = new RtAudio(RtAudio::MACOSX_CORE);
    if ( dac->getDeviceCount() == 0 )
    {
        delete dac;
        exit( 0 );
    }
    
    AEffect *effect;
    
    std::mutex *mtx = new std::mutex();
    
    VstEvents *events = new VstEvents();
    events->numEvents = 0;
    
    
    if (!checkPlatform ())
    {
        printf ("Platform verification failed! Please check your Compiler Settings!\n");
        return -1;
    }
    
    const char* fileName = "/Library/Audio/Plug-Ins/VST/FM8.vst";
    
    printf ("HOST> Load library...\n");
    PluginLoader loader;
    if (!loader.loadLibrary (fileName))
    {
        printf ("Failed to load VST Plugin library!\n");
        return -1;
    }
    
    PluginEntryProc mainEntry = loader.getMainEntry ();
    if (!mainEntry)
    {
        printf ("VST Plugin main entry not found!\n");
        return -1;
    }
    
    printf ("HOST> Create effect...\n");
    effect = mainEntry (HostCallback);
    if (!effect)
    {
        printf ("Failed to create effect instance!\n");
        return -1;
    }
    
    printf ("HOST> Init sequence...\n");
    effect->dispatcher (effect, effOpen, 0, 0, 0, 0);
    effect->dispatcher (effect, effSetSampleRate, 0, 0, 0, kSampleRate);
    effect->dispatcher (effect, effSetBlockSize, 0, kBlockSize, 0, 0);
    
    
    
    checkEffectProperties (effect);
    checkEffectProcessing(effect);
    
    
    AudioIO *audioIO = new AudioIO();
    audioIO->mtx = mtx;
    audioIO->effect = effect;
    audioIO->events = events;
    audioIO->dac = dac;
    audioIO->InitializeAudio();
    
    MidiState *midiState = new MidiState();
    midiState->mtx = mtx;
    midiState->effect = effect;
    midiState->events = events;
    midiState->dac = dac;
    
    AppDelegate *appDelegate = [[AppDelegate alloc] init];
    
    appDelegate->mtx = mtx;
    appDelegate->effect = effect;
    appDelegate->events = events;
    appDelegate->dac = dac;
    appDelegate->midiState = midiState;
    appDelegate->view->midiState = midiState;
    appDelegate->audioIO = audioIO;
    
    [appDelegate checkEffectEditor];

    
    [NSApp setDelegate:appDelegate];
    [NSApp run];
    
    
}




