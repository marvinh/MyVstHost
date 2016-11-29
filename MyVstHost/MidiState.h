//
//  MidiState.h
//  MyVstHost
//
//  Created by marvin h on 8/8/16.
//  Copyright © 2016 marvin h. All rights reserved.
//

#ifndef MidiState_h
#define MidiState_h

#include "pluginterfaces/vst2.x/aeffectx.h"

class MidiState
{
public:
    MidiState()
    {
        baseNote = 60;
        velocity = 100;
        
        for(int i = 0; i < 128 ; i++)
        {
            noteOnArray[i] = false;
        }
        
    }
    ~MidiState()
    {
    
    }
    
    void NoteOn(char offsetFromOctave)
    {
        
        if(noteOnArray[offsetFromOctave+baseNote] == false)
        {
            mtx->lock();
            events->events[events->numEvents] = new VstEvent();
            VstMidiEvent *event = (VstMidiEvent*)events->events[events->numEvents];
            events->numEvents++;
            
            event->deltaFrames = ((int)(dac->getStreamTime()*44100))%512;
            event->midiData[0] = 0x90 | 0;
            event->midiData[1] = baseNote+offsetFromOctave;
            event->midiData[2] = velocity;
            event->type = kVstMidiType;
            event->byteSize = sizeof(VstMidiEvent);
            event->flags = 1;
            
            noteOnArray[offsetFromOctave+baseNote] = true;
            
            mtx->unlock();
        }
    }
    void NoteOff(char offsetFromOctave)
    {
        mtx->lock();
        
        events->events[events->numEvents] = new VstEvent();
        VstMidiEvent *event = (VstMidiEvent*)events->events[events->numEvents];
        events->numEvents++;
        
        event->deltaFrames = ((int)(dac->getStreamTime()*44100))%512;
        event->midiData[0] = 0x80 | 0;
        event->midiData[1] = baseNote+offsetFromOctave;
        event->midiData[2] = velocity;
        event->type = kVstMidiType;
        event->byteSize = sizeof(VstMidiEvent);
        event->flags = 1;
        
        noteOnArray[offsetFromOctave+baseNote] = false;
        
        mtx->unlock();
    }
    void AllNotesOff()
    {
        mtx->lock();
        
        effect->dispatcher(effect, effProcessEvents, 0, 0, events, 0);
        
        for(int i = 0; i < events->numEvents; i++)
        {
            if(events->events[i])
            {
                delete events->events[i];
            }
        }
        
        events->numEvents = 0;
        
        
        for(int i = 0; i < 128; i++)
        {
            
            events->events[events->numEvents] = new VstEvent();
            VstMidiEvent *event = (VstMidiEvent*)events->events[events->numEvents];
            event->deltaFrames = ((int)(dac->getStreamTime()*44100))%512;
            event->midiData[0] = 0x80 | 0;
            event->midiData[1] = i;
            event->midiData[2] = velocity;
            event->type = kVstMidiType;
            event->byteSize = sizeof(VstMidiEvent);
            event->flags = 1;
            events->numEvents++;
            noteOnArray[i] = false;
        }
        
        effect->dispatcher(effect, effProcessEvents, 0, 0, events, 0);
        
        for(int i = 0; i < events->numEvents; i++)
        {
            if(events->events[i])
            {
                delete events->events[i];
            }
        }
        
        events->numEvents = 0;
        mtx->unlock();
    }
    
    void VelocityUp()
    {
        if(velocity < 120)
        {
            velocity += 20;
        }
        else
        {
            velocity = 127;
        }
    }
    void VelocityDown()
    {
        if(velocity == 127)
        {
            velocity = 120;
        }
        else if(velocity > 20)
        {
            velocity -=20;
        }
        else
        {
            velocity = 1;
        }
    }
    void OctaveUp()
    {
        AllNotesOff();
        if(baseNote < 100)
        {
            baseNote += 12;
        }
    }
    void OctaveDown()
    {
        AllNotesOff();
        if(baseNote > 0)
        {
            baseNote -= 12;
        }
        
    }

    AEffect *effect;
    RtAudio *dac;
    VstEvents *events;
    std::mutex *mtx;
    bool noteOnArray[128];
    
private:
    char baseNote;
    char velocity;
    
    
};

#endif /* MidiState_h */
