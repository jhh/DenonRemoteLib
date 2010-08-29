//
//  DRSession+Commands.m
//  DenonEngine
//
//  Created by Jeff Hutchison on 3/28/10.
//  Copyright 2010 Jeffrey Hutchison. All rights reserved.
//

#import "DRSession+Commands.h"


@implementation DRSession (Commands)

- (void)queryStandby {
  [self sendCommand:@"PW?\r"];
}

- (void)queryMute {
  [self sendCommand:@"MU?\r"];
}

- (void)queryMasterVolume {
  [self sendCommand:@"MV?\r"];
}

- (void)queryInputSource {
  [self sendCommand:@"SI?\r"];
}

- (void)sendPower:(DRState)state {
  if (state == DROnState) {
    [self sendCommand:@"PWON\r"];
  } else {
    [self sendCommand:@"PWSTANDBY\r"];
  }
}

- (void)sendMute:(DRState)state {
  if (state == DROnState) {
    [self sendCommand:@"MUON\r"];
  } else {
    [self sendCommand:@"MUOFF\r"];
  }
}

- (void)sendMasterVolume:(float)volume {
  volume += 80.0;
  NSParameterAssert((volume > 0) && (volume < 80));
  [self sendCommand:[NSString stringWithFormat:@"MV%02i\r", lroundf(volume)]];
}

- (void)sendInputSource:(NSString *)source {
  [self sendCommand:[NSString stringWithFormat:@"SI%@\r", source]];
}

@end
