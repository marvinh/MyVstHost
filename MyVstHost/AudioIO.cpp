//
//  AudioIO.cpp
//  MyVstHost
//
//  Created by marvin h on 8/14/16.
//  Copyright © 2016 marvin h. All rights reserved.
//

#include <stdio.h>
#include "AudioIO.h"

AEffect *AudioIO::effect;
VstEvents *AudioIO::events;
std::mutex *AudioIO::mtx;

AudioIO::AudioIO()
{
    
}
int AudioIO::AudioCallback( void *outputBuffer, void *inputBuffer, unsigned int nBufferFrames,
                           double streamTime, RtAudioStreamStatus status, void *data )
{
    if ( status )
        std::cout << "Stream underflow detected!" << std::endl;
    
    float* inputBufferF = (float*)inputBuffer;
    float* outputBufferF = (float*)outputBuffer;
    
    mtx->lock();
    if(events->numEvents>0)
    {
        
        effect->dispatcher(effect, effProcessEvents, 0, 0, events, 0);
    }
    for(int i = 0; i < nBufferFrames ; i++)
    {
        if(i==0)
        {
            float *inputs[2] = {inputBufferF, inputBufferF+nBufferFrames};
            float *outputs[2] = {outputBufferF,outputBufferF+nBufferFrames};
            effect->processReplacing(effect,inputs,outputs,nBufferFrames);
        }
    }
    
    for(int i = 0; i < events->numEvents; i++)
    {
        if(events->events[i])
        {
            delete events->events[i];
        }
    }
    events->numEvents = 0;
    
    mtx->unlock();
    
    return 0;
}

void AudioIO::InitializeAudio()
{
    
    
    RtAudio::StreamParameters oParams;
    oParams.deviceId = dac->getDefaultOutputDevice();
    oParams.nChannels = 2;
    
    RtAudio::StreamParameters iParams;
    iParams.deviceId = dac->getDefaultInputDevice();
    iParams.nChannels = 2;
  
    
    
    
    unsigned int sampleRate = 44100;
    unsigned int bufferFrames = 512; // 512 sample frames
    RtAudio::StreamOptions options;
    
    options.flags = RTAUDIO_NONINTERLEAVED | RTAUDIO_SCHEDULE_REALTIME;
    options.priority = 0;
    try {
        dac->openStream( &oParams, &iParams, RTAUDIO_FLOAT32,
                        sampleRate, &bufferFrames,&AudioCallback, NULL, &options );
        dac->startStream();
    }
    catch ( RtAudioError& e ) {
        std::cout << '\n' << e.getMessage() << '\n' << std::endl;
        exit( 0 );
    }
    
}