//
//  VirtualMidiSource.h
//  Breathless
//
//  Created by Vinicius Mello on 02/04/15.
//  Copyright (c) 2015 Vinicius Mello. All rights reserved.
//

#ifndef Breathless_VirtualMidiSource_h
#define Breathless_VirtualMidiSource_h
#import <Foundation/Foundation.h>
#import <CoreMIDI/MIDINetworkSession.h>
#import <CoreMIDI/CoreMIDI.h>

@interface VirtualSourceMidi : NSObject {
    NSString * _name;
    BOOL _virtualEnabled;
    MIDIClientRef      virtualMidiClient;
    MIDIPortRef        outPort;
    MIDIEndpointRef    midiOut;
    MIDINetworkSession* networkSession;
}
@property (copy) NSString *name;
@property BOOL virtualEnabled;
- (id)init:(NSString *)aName;
- (void)sendBytes:(const UInt8*)bytes;
- (void)sendBytes:(const UInt8*)bytes size:(UInt32)size;
@end

#endif
