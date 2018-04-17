//
//  VirtualMidiSource.m
//  Breathless
//
//  Created by Vinicius Mello on 02/04/15.
//  Copyright (c) 2015 Vinicius Mello. All rights reserved.
//

#import "VirtualMidiSource.h"
void printPacketInfo(const MIDIPacket* packet);
NSString *getDisplayName(MIDIObjectRef object);

double expr=0.0;
UInt8 exprCC = 11;

void MIDIOnInput (
                  const MIDIPacketList *packets,
                  void                 *context,
                  void                 *sourceContext
                  ) { // MIDIOnInput function
//    @autoreleasepool {
//        id wrapper = (__bridge id)context;
//
//        [wrapper sendInputMessagesForReciever:(MIDIPacketList *)packets];
//}
//    id wrapper = (__bridge id)context;
    MIDIPacket *packet = (MIDIPacket*)packets->packet;
    int j;
    int count = packets->numPackets;
    for (j=0; j<count; j++) {
        if((packet->data[0]&0xf0)==0xb0) {
            if(packet->data[1]==exprCC) {
                expr=((double)packet->data[2]);
            }
        }
        //printPacketInfo(packet);
        packet = MIDIPacketNext(packet);
    }
}

void printPacketInfo(const MIDIPacket* packet) {
    double timeinsec = packet->timeStamp / (double)1e9;
    printf("%9.3lf\t", timeinsec);
    int i;
    for (i=0; i<packet->length; i++) {
        if (packet->data[i] < 0x7f) {
            printf("%d ", packet->data[i]);
        } else {
            printf("0x%x ", packet->data[i]);
        }
    }
    printf("\n");
}

NSString *getDisplayName(MIDIObjectRef object)
{
    // Returns the display name of a given MIDIObjectRef as an NSString
    CFStringRef name = nil;
    if (noErr != MIDIObjectGetStringProperty(object, kMIDIPropertyDisplayName, &name))
        return nil;
    return (__bridge NSString *)name;
}

void MyMIDINotifyProc (const MIDINotification  *message, void *refCon) {
    //printf("MIDI Notify, messageId=%d,", (int)message->messageID);
    id wrapper = (__bridge id)refCon;
    [wrapper reconnect];
}

@implementation VirtualSourceMidi

- (id)init:(NSString *)aName {
    self = [super init];
    if (self) {
        _name = [aName copy];
        _virtualEnabled = true;
        MIDIClientCreate((__bridge CFStringRef)[_name stringByAppendingString:@"VirtualCllient"],MyMIDINotifyProc,(__bridge void *)(self),&virtualMidiClient);
        MIDIInputPortCreate(virtualMidiClient,(__bridge CFStringRef)_name, MIDIOnInput,(__bridge void *)(self),&midiIn);
        ItemCount nSrcs = MIDIGetNumberOfSources();
        ItemCount iSrc;
        for (iSrc=0; iSrc<nSrcs; iSrc++) {
            MIDIEndpointRef src = MIDIGetSource(iSrc);
            if (src != 0) {
                NSLog(@"  Source: %@", getDisplayName(src));
                MIDIPortConnectSource(midiIn, src, NULL);
            }
        }
        MIDISourceCreate(virtualMidiClient,(__bridge CFStringRef)_name,&midiOut);
        
        printf("xxx");
        networkSession = [MIDINetworkSession defaultSession];
    }
    return self;
}

- (double)getExpression {
    return expr/127.0;
}

- (void)setExprCC:(const UInt8)cc {
    exprCC = cc;
}

- (void)reconnect {
    ItemCount nSrcs = MIDIGetNumberOfSources();
    ItemCount iSrc;
    for (iSrc=0; iSrc<nSrcs; iSrc++) {
        MIDIEndpointRef src = MIDIGetSource(iSrc);
        if (src != 0) {
            if(![getDisplayName(src) isEqualToString:_name]) {
            NSLog(@" Reconnect Source: %@", getDisplayName(src));
//            MIDIPortDisconnectSource(midiIn, src);
            MIDIPortConnectSource(midiIn, src, NULL);
            }
        }
    }
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
