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
#import "AsyncSocket.h"
#import "DRDebuggingMacros.h"

@implementation DRSession

@synthesize delegate = _delegate;

#pragma mark -
#pragma mark init & dealloc methods

- (id) initWithHostName:(NSString *)host {
    // default to telnet port 23
    return [self initWithHostName:host port:23];
}

- (id) initWithHostName:(NSString *)host port:(NSInteger)port {
    if ( (self = [super init]) ) {
        socket = [[AsyncSocket alloc] initWithDelegate:self];

        // continue to send commands during mouse drags
        [socket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];

        // TODO: implement connect method to handle error
        [socket connectToHost:host onPort:port withTimeout:1.0 error:NULL];

        // -onSocket:didWriteDataWithTag: will queue first read after first write
        // on new socket, subsequent reads are called during -onSocket:didReadData:withTag:
        _firstWrite = YES;
    }
    return self;
}

- (void) dealloc {
    [socket release];
    [super dealloc];
}

#pragma mark -
#pragma mark DRSession methods

- (void) sendCommand:(NSString *)commandString {
    NSData * command = [commandString dataUsingEncoding:NSASCIIStringEncoding];
    DLog(@"%@", commandString);
    [socket writeData:command withTimeout:1.0 tag:0L];
}

- (void) close {
    [socket disconnect];
    [socket release];
}

#pragma mark -
#pragma mark AsyncSocket delegate call-backs

-(void)onSocketDidDisconnect:(AsyncSocket *)sock {
    DLog(@"socket did disconnect");
}

-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err {
    DLog(@"socket will disconnect with error: %@", err);
}


-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    DLog(@"%@", socket);
}

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData*)data withTag:(long)tag {
    NSString * reply = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
    NSString * trimmedReply = [reply stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    DLog(@"socket received data: %@", reply);
    DREvent *event = [[[DREvent alloc] initWithRawEvent:trimmedReply] autorelease];
    [self.delegate session:self didReceiveEvent:event];
    [socket readDataToData:[AsyncSocket CRData] withTimeout:-1.0 tag:0];
}

-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
    if (_firstWrite) {
        DLog(@"socket did write data, reading data first time");
        [socket readDataToData:[AsyncSocket CRData] withTimeout:-1.0 tag:0];
        _firstWrite = NO;
    }
}


@end
