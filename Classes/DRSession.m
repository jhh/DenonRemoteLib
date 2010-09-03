// DRSession.m
// DenonRemoteLib
//
// Copyright 2010 Jeffrey Hutchison
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "DRSession.h"
#import "DREvent.h"
#import "NSStream+Additions.h"
#import "DRDebuggingMacros.h"

NSString * const DRRemoteEventReceivedNotification = @"DREventReceived";
NSString * const DRRemoteEventKey = @"event";

@interface DRSession ()
- (void)processOutgoingBytes;
- (void)readIncomingBytes;
- (void)processResponse;
- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode;
@end

@implementation DRSession

@synthesize delegate = delegate_;

- (id) initWithHostName:(NSString *)host {
    // default to telnet port
    return [self initWithHostName:host port:23];
}

- (id) initWithHostName:(NSString *)host port:(NSInteger)port {
    if (self = [super init]) {
        oBuffer_ = [[NSMutableData alloc] init];
        iBuffer_ = [[NSMutableData alloc] init];
        
        [NSStream getStreamsToHostNamed:host
                                   port:port
                            inputStream:&iStream_
                           outputStream:&oStream_];
        
        [iStream_ retain];
        [oStream_ retain];
        
        [iStream_ setDelegate:self];
        [oStream_ setDelegate:self];
        
        [iStream_ scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [oStream_ scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        // oStream_ is opened later in -stream:handleEvent:
        [iStream_ open];
    }
    return self;
}

- (void) close {
    [iStream_ setDelegate:nil];
    [iStream_ removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [iStream_ close];
    [iStream_ setDelegate:nil];
    [oStream_ close];
    [oStream_ removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void) dealloc {
    [iStream_ release];
    [oStream_ release];
    [iBuffer_ release];
    [oBuffer_ release];
    [super dealloc];
}

- (void) sendCommand:(NSString *)command {
    DLog(@"%@", command);
    [oBuffer_ appendData:[command dataUsingEncoding:NSASCIIStringEncoding]];
    [self processOutgoingBytes];
}

- (void) processResponse {
    unsigned start = 0;
    unsigned ilen = [iBuffer_ length];
    
    for (int i = 0; i < ilen; i++) {
        if (*((char *)[iBuffer_ bytes] + i) == '\r') {
            // copy current response to string
            NSString *resp = [[[NSString alloc] initWithBytes:[iBuffer_ bytes] + start
                                                       length:i - start
                                                     encoding:NSASCIIStringEncoding] autorelease];
            
            DREvent *event = [[[DREvent alloc] initWithEvent:resp] autorelease];
            
            start = i + 1;
            DLog(@"%@", event);
            [[self delegate] session:self didReceiveEvent:event];
        }
    }
    memmove([iBuffer_ mutableBytes], [iBuffer_ mutableBytes] + start, ilen - start);
    [iBuffer_ setLength:ilen - start];
}

- (void) processOutgoingBytes {
    // write as many bytes as possible from buffered bytes.
    if (![oStream_ hasSpaceAvailable]) return;
    
    unsigned olen = [oBuffer_ length];
    if (olen > 0) {
        int writ = [oStream_ write:[oBuffer_ bytes] maxLength:olen];
        // buffer any unwritten bytes for later writing
        if (writ < olen) {
            memmove([oBuffer_ mutableBytes], [oBuffer_ mutableBytes] + writ, olen - writ);
            [oBuffer_ setLength:olen - writ];
            return;
        }
        [oBuffer_ setLength:0];
    }
}

- (void) readIncomingBytes {
    if (![iStream_ hasBytesAvailable]) return;
    
    uint8_t buf[512];
    unsigned int len = 0;
    // FIXME: why cast?
    len = [(NSInputStream *)iStream_ read:buf maxLength:sizeof(buf)];
    if (len)
        [iBuffer_ appendBytes:(const void *)buf length:len];
    else
        if ([iStream_ streamStatus] != NSStreamStatusAtEnd)
            DLog(@"failed to read data from network!");
}

- (void) stream:(NSStream*)stream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            if (stream == iStream_) {
                [oStream_ open];
            }
            break;
        }
        case NSStreamEventHasBytesAvailable: {
            [self readIncomingBytes];
            [self processResponse];
            break;
        }
        case NSStreamEventHasSpaceAvailable: {
            [self processOutgoingBytes];
            break;
        }
        case NSStreamEventEndEncountered: {
            [stream close];
            [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            break;
        }
        case NSStreamEventErrorOccurred: {
            NSError *error = [stream streamError];
            DLog(@"%@ error: %@", stream, error);
            [[self delegate] session:self didFailWithError:error];
            [stream close];
            [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            break;
        }
        default:
            break;
    }
}

@end
