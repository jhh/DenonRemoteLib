//
//  DRSession.h
//  DenonEngine
//
//  Created by Jeff Hutchison on 3/28/10.
//  Copyright 2010 Jeffrey Hutchison. All rights reserved.
//

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
