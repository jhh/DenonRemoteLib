// DRSession.h
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

#import <Foundation/Foundation.h>
@class DRSession;
@class AsyncSocket;
@class DREvent;

@protocol DRSessionDelegate

- (void) session:(DRSession *)session didReceiveEvent:(DREvent *)event;
- (void) session:(DRSession *)session didFailWithError:(NSError *)error;

@end


@interface DRSession : NSObject {
    
@private
    AsyncSocket * socket;
    id<DRSessionDelegate> _delegate;
    BOOL _firstWrite;
}

@property  id<DRSessionDelegate> delegate;

- (id) initWithHostName:(NSString *)host;
- (id) initWithHostName:(NSString *)host port:(NSInteger)port;
- (void) sendCommand:(NSString *)command;
- (void) close;

@end

