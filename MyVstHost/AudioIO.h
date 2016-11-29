//
//  AudioIO.h
//  MyVstHost
//
//  Created by marvin h on 8/8/16.
//  Copyright © 2016 marvin h. All rights reserved.
//

#ifndef AudioIO_h
#define AudioIO_h

#include "pluginterfaces/vst2.x/aeffectx.h"
#include "RtAudio.h"

class AudioIO
{
public:
    AudioIO();
    
    static int AudioCallback( void *outputBuffer, void *inputBuffer, unsigned int nBufferFrames,
                             double streamTime, RtAudioStreamStatus status, void *data );
    
    
    void InitializeAudio();

    RtAudio *dac;
    static VstEvents *events;
    static AEffect *effect;
    static std::mutex *mtx;
};

#endif /* AudioIO_h */
