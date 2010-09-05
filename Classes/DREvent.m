// DREvent.m
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

#import "DREvent.h"
#import "DRInputSource.h"
#import "DRDebuggingMacros.h"

NSString * const DRHDPInputSource        = @"HDP";
NSString * const DRTVCableInputSource    = @"TV/CBL";
NSString * const DRHDRadioInputSource    = @"HDRADIO";
NSString * const DRNetUSBInputSource     = @"NET/USB";
NSString * const DRDVDInputSource        = @"DVD";
NSString * const DRSatelliteInputSource  = @"SAT";


// private methods
@interface DREvent ()
- (void)parseEventType;
- (void)parseParameter;
@end

@implementation DREvent

@synthesize rawEvent = rawEvent_;
@synthesize parameter = parameter_;
@synthesize eventType = eventType_;

#pragma mark -
#pragma mark Memory Methods
- (id) initWithRawEvent:(NSString *)raw {
    if((self = [super init])) {
        rawEvent_ = [raw retain];
        [self parseEventType];
        [self parseParameter];
    }
    return self;
}

- (void) dealloc {
    [[self rawEvent] release];
    [parameter_ release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessor Methods

- (float) floatValue {
    float value = 0.0;
    NSString *p = [self parameter];
    switch ([parameter_ length]) {
        case 2:
            value = [p floatValue] - 80.0;
            break;
        case 3:
            value = ([p floatValue] / 10.0) - 80.0;
            break;
        case 6:
            value = [p floatValue] / 100.0;
            break;
        default:
            break;
    }
    return value;
}

- (BOOL) boolValue {
    return [[self parameter] hasPrefix:@"ON"];
}

- (NSString *) stringValue {
    return [self parameter];
}

- (NSString *) description {
    return [NSString stringWithFormat:@"%@ (%u): %@",
            [self rawEvent], [self eventType], [self parameter]] ;
}

- (DRInputSource *) inputSource {
    ZAssert(self.eventType == DenonInputSourceNameEvent || self.eventType == DenonInputSourceUsageEvent,
            @"do not use this accessor with this type of event: %@", self);
    return [[[DRInputSource alloc] initWithEvent:self] autorelease];
}

#pragma mark -
#pragma mark Parser Methods

- (void) parseEventType {
    switch ([[self rawEvent] characterAtIndex:0]) {
        case 'M':
            // MV, MU, MS
            switch ([[self rawEvent] characterAtIndex:1]) {
                case 'V':
                    if ([[self rawEvent] characterAtIndex:2] == 'M') {
                        [self setEventType:DenonMasterVolumeMaxEvent];
                    } else {
                        [self setEventType:DenonMasterVolumeEvent];
                    }
                    return;
                case 'U':
                    [self setEventType:DenonMuteEvent];
                    return;
                case 'S':
                    [self setEventType:DenonSurroundModeEvent];
                    return;
            }
            break; // M
        case 'P':
            // PW, PS, PV
            switch ([[self rawEvent] characterAtIndex:1]) {
                case 'W':
                    [self setEventType:DenonPowerEvent];
                    return;
                case 'S':
                    [self setEventType:DenonAudioParameterEvent];
                    return;
                case 'V':
                    [self setEventType:DenonPictureAdjustEvent];
                    return;
            }
            break; // P
        case 'S':
            // SI, SR, SD, SV, SY, SS
            switch ([[self rawEvent] characterAtIndex:1]) {
                case 'I':
                    [self setEventType:DenonInputSourceEvent];
                    return;
                case 'R':
                    [self setEventType:DenonRecordSelectEvent];
                    return;
                case 'D':
                    [self setEventType:DenonInputModeEvent];
                    return;
                case 'V':
                    [self setEventType:DenonVideoSelectModeEvent];
                    return;
                case 'Y':
                    [self setEventType:DenonLockEvent];
                    return;
                case 'S':
                    if ([[self rawEvent] hasPrefix:@"SSFUN"]) {
                        [self setEventType:DenonInputSourceNameEvent];
                    } else if ([[self rawEvent] hasPrefix:@"SSSPC"]) {
                        [self setEventType:DenonSpeakerStatusEvent];
                    } else if ([[self rawEvent] hasPrefix:@"SSSOD"]) {
                        [self setEventType:DenonInputSourceUsageEvent];
                    } else {
                        [self setEventType:DenonUnknownEvent];
                    }
                    return;
            }
            break; // S
        case 'Z':
            // ZM, Z2, Z3, Z4
            switch ([[self rawEvent] characterAtIndex:1]) {
                case 'M':
                    [self setEventType:DenonMainZoneEvent];
                    return;
                case '2':
                    [self setEventType:DenonZone2Event];
                    return;
                case '3':
                    [self setEventType:DenonZone3Event];
                    return;
                case '4':
                    [self setEventType:DenonZone4Event];
                    return;
                default:
                    [NSException raise:NSInternalInconsistencyException
                                format:@"Unrecognized event - %@", rawEvent_];
                    break;
            }
            break; // Z
        case 'T':
            // TF, TP, TM
            switch ([[self rawEvent] characterAtIndex:1]) {
                case 'F':
                    switch ([[self rawEvent] characterAtIndex:2]) {
                        case 'A':
                            [self setEventType:DenonAnalogRadioFrequencyEvent];
                            return;
                        case 'X':
                            [self setEventType:DenonXMRadioFrequencyEvent];
                            return;
                        case 'H':
                            if ([[self rawEvent] characterAtIndex:4] == 'M') {
                                [self setEventType:DenonHDRadioMulticastChannelEvent];
                            } else {
                                [self setEventType:DenonHDRadioFrequencyEvent];
                            }
                            return;
                        case 'D':
                            [self setEventType:DenonDABRadioFrequencyEvent];
                            return;
                        default:
                            break;
                    }
                case 'P':
                    switch ([[self rawEvent] characterAtIndex:2]) {
                        case 'A':
                            [self setEventType:DenonAnalogRadioPresetEvent];
                            return;
                        case 'X':
                            [self setEventType:DenonXMRadioPresetEvent];
                            return;
                        case 'H':
                            [self setEventType:DenonHDRadioPresetEvent];
                            return;
                        case 'D':
                            [self setEventType:DenonDABRadioPresetEvent];
                            return;
                        default:
                            break;
                    }
                case 'M':
                    switch ([[self rawEvent] characterAtIndex:2]) {
                        case 'A':
                            [self setEventType:DenonAnalogRadioBandOrModeEvent];
                            return;
                        case 'H':
                            [self setEventType:DenonHDRadioBandOrModeEvent];
                            return;
                        case 'D':
                            [self setEventType:DenonDABRadioBandOrModeEvent];
                            return;
                        default:
                            break;
                    }
            }
            break; // T
        case 'D':
            // DC, DA
            switch ([[self rawEvent] characterAtIndex:1]) {
                case 'C':
                    [self setEventType:DenonDigitalInputModeEvent];
                    return;
                case 'A':
                    [self setEventType:DenonRadioDABStatusEvent];
                    return;
            }
            break; // D
        case 'N':
            // NSA, NSE, NSR, NSH
            switch ([[self rawEvent] characterAtIndex:2]) {
                case 'A':
                    [self setEventType:DenonNetUSBDisplayASCIIEvent];
                    return;
                case 'E':
                    [self setEventType:DenonNetUSBDisplayUTF8Event];
                    return;
                case 'R':
                    [self setEventType:DenonNSREvent];
                    return;
                case 'H':
                    [self setEventType:DenonNSHEvent];
                    return;
            }
            break; // N
        case 'I':
            // IPA, IPE
            switch ([[self rawEvent] characterAtIndex:2]) {
                case 'A':
                    [self setEventType:DenoniPodDisplayASCIIEvent];
                    return;
                case 'E':
                    [self setEventType:DenoniPodDisplayUTF8Event];
                    return;
                default:
                    break;
            }
            break; // I
        case 'C':
            // CVFL/R, CVC, CVSW, CVSL/R, CVSBL/R, CVSB
            switch ([[self rawEvent] characterAtIndex:2]) {
                case 'F':
                    if ([[self rawEvent] characterAtIndex:3] == 'L') {
                        [self setEventType:DenonChannelVolumeFrontLeftEvent];                        
                    } else if ([[self rawEvent] characterAtIndex:3] == 'R') {
                        [self setEventType:DenonChannelVolumeFrontRightEvent];
                    }
                    return;
                case 'C':
                    [self setEventType:DenonChannelVolumeCenterEvent];
                    return;
                case 'S':
                    switch ([[self rawEvent] characterAtIndex:3]) {
                        case 'L':
                            [self setEventType:DenonChannelVolumeSurroundLeftEvent];
                            return;
                        case 'R':
                            [self setEventType:DenonChannelVolumeSurroundRightEvent];
                            return;
                        case 'W':
                            [self setEventType:DenonChannelVolumeSubwooferEvent];
                            return;
                        case 'B':
                            switch ([[self rawEvent] characterAtIndex:4]) {
                                case ' ':
                                    [self setEventType:DenonChannelVolumeSurroundBackEvent];
                                    return;
                                case 'L':
                                    [self setEventType:DenonChannelVolumeSurroundBackLeftEvent];
                                    return;
                                case 'R':
                                    [self setEventType:DenonChannelVolumeSurroundBackRightEvent];
                                    return;
                                default:
                                    break;
                            }
                        default:
                            break;
                    }
                default:
                    break;
            }
            break;
        case 'H':
            if ([[self rawEvent] characterAtIndex:1] == 'D') {
                [self setEventType:DenonRadioHDStatusEvent];
                return;
            }
            break;
        case 'X':
            if ([[self rawEvent] characterAtIndex:1] == 'M') {
                [self setEventType:DenonRadioXMStatusEvent];
                return;
            }
            break;
        case 'V':
            if ([[self rawEvent] characterAtIndex:1] == 'S') {
                [self setEventType:DenonHDMISettingEvent];
                return;
            }
            break;
        case 'R':
            if ([[self rawEvent] characterAtIndex:1] == 'M') {
                [self setEventType:DenonRMEvent];
                return;
            }
            break;
    }
    DLog(@"unknown event received: %@", rawEvent_);
    [self setEventType:DenonUnknownEvent];
}

- (void) parseParameter {
    NSInteger index;
    switch (eventType_) {
        case DenonPowerEvent:
        case DenonMainZoneEvent:
        case DenonMuteEvent:
        case DenonMasterVolumeEvent:
        case DenonInputSourceEvent:
        case DenonVideoSelectModeEvent:
            index = 2;
            break;
        case DenonChannelVolumeCenterEvent:
        case DenonHDRadioFrequencyEvent:
            index = 4;
            break;
        case DenonChannelVolumeFrontLeftEvent:
        case DenonChannelVolumeFrontRightEvent:
        case DenonChannelVolumeSubwooferEvent:
        case DenonChannelVolumeSurroundLeftEvent:
        case DenonChannelVolumeSurroundRightEvent:
        case DenonChannelVolumeSurroundBackEvent:
        case DenonInputSourceNameEvent:
        case DenonInputSourceUsageEvent:
            index = 5;
            break;
        case DenonMasterVolumeMaxEvent:
        case DenonChannelVolumeSurroundBackLeftEvent:
        case DenonChannelVolumeSurroundBackRightEvent:
            index = 6;
            break;
        default:
            index = 0;
            break;
    }
    [self setParameter:[[self rawEvent] substringFromIndex:index]];
}

@end
