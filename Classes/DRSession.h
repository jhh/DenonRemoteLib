// DRSession.h
//
// Copyright 2010 Jeffrey Hutchiosn
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
@class DREvent;

extern NSString * const DRRemoteEventReceivedNotification;
extern NSString * const DRRemoteEventKey;

@protocol DRSessionDelegate

- (void) session:(DRSession *)session didReceiveEvent:(DREvent *)event;
- (void) session:(DRSession *)session didFailWithError:(NSError *)error;

@end


#if TARGET_OS_IPHONE

@interface DRSession : NSObject {

#else

@interface DRSession : NSObject <NSStreamDelegate> {

#endif
  
@private
  NSInputStream *iStream_;
  NSOutputStream *oStream_;
  NSMutableData *iBuffer_;
  NSMutableData *oBuffer_;
  id<DRSessionDelegate> delegate_;    
  
}

@property (assign) id<DRSessionDelegate> delegate;

- (id)initWithHostName:(NSString *)host;
- (id)initWithHostName:(NSString *)host port:(NSInteger)port;
- (void)sendCommand:(NSString *)command;
- (void)close;

@end
