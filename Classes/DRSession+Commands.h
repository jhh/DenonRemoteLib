//
//  DRSession+Commands.h
//  DenonEngine
//
//  Created by Jeff Hutchison on 3/28/10.
//  Copyright 2010 Jeffrey Hutchison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRSession.h"

enum {
  DROffState = 0,
  DROnState  = 1
};
typedef NSUInteger DRState;

@interface DRSession (Commands)

- (void)queryStandby;
- (void)queryMute;
- (void)queryMasterVolume;
- (void)queryInputSource;
- (void)sendPower:(DRState)state;
- (void)sendMute:(DRState)state;
- (void)sendMasterVolume:(float)volume;
- (void)sendInputSource:(NSString *)source;

@end
