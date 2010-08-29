// DRSession+Commands.m
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

#import "DRSession+Commands.h"
#import "DRDebuggingMacros.h"

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
