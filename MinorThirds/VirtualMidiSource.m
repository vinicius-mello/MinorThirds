//
//  VirtualMidiSource.m
//  Breathless
//
//  Created by Vinicius Mello on 02/04/15.
//  Copyright (c) 2015 Vinicius Mello. All rights reserved.
//

#import "VirtualMidiSource.h"

@implementation VirtualSourceMidi

- (id)init:(NSString *)aName {
    self = [super init];
    if (self) {
        _name = [aName copy];
        _virtualEnabled = true;
        MIDIClientCreate((__bridge CFStringRef)[_name stringByAppendingString:@"VirtualCllient"],NULL,NULL,&virtualMidiClient);
        MIDISourceCreate(virtualMidiClient,(__bridge CFStringRef)_name,&midiOut);
        networkSession = [MIDINetworkSession defaultSession];
    }
    return self;
}

- (void)sendBytes:(const UInt8*)bytes {
    [self sendBytes: bytes size: 3];
}

- (void)sendBytes:(const UInt8*)bytes size:(UInt32)size {
    Byte packetBuffer[size+100];
    MIDIPacketList *packetList = (MIDIPacketList*)packetBuffer;
    MIDIPacket     *packet     = MIDIPacketListInit(packetList);
    
    packet = MIDIPacketListAdd(packetList, sizeof(packetBuffer), packet, 0, size, bytes);
    if(!_virtualEnabled) {
        for (ItemCount index = 0; index < MIDIGetNumberOfDestinations(); ++index)
        {
            MIDIEndpointRef outputEndpoint = MIDIGetDestination(index);
            if (outputEndpoint)
            {
                /*OSStatus s = */MIDISend(outPort, outputEndpoint, packetList);
            }
        }
    } else {
        MIDIReceived(midiOut, packetList);
    }
}

- (BOOL)virtualEnabled {
    return _virtualEnabled;
}

- (void)setVirtualEnabled: (BOOL)newStatus {
    if (_virtualEnabled == newStatus) {
        return;
    }
    if (_virtualEnabled) {
        MIDIEndpointDispose(midiOut);
        networkSession.enabled = true;
        networkSession.connectionPolicy = MIDINetworkConnectionPolicy_Anyone;
        MIDIOutputPortCreate(virtualMidiClient, (__bridge CFStringRef)[_name stringByAppendingString:@"OutPort"], &outPort);
    } else {
        MIDIPortDispose(outPort);
        networkSession.enabled = false;
        MIDISourceCreate(virtualMidiClient, (__bridge CFStringRef)_name, &midiOut);
    }
    _virtualEnabled = newStatus;
}

@end