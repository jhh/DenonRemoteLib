// DREvent.h
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
@class DRInputSource;

enum {
    DenonUnknownEvent,
    DenonPowerEvent,                           // PW
    DenonMasterVolumeEvent,                    // MV
    DenonMuteEvent,                            // MU
    DenonInputSourceEvent,                     // SI
    DenonInputSourceNameEvent,                 // SSFUN
    DenonInputSourceUsageEvent,                // SSSOD
    DenonMainZoneEvent,                        // ZM
    DenonRecordSelectEvent,                    // SR
    DenonInputModeEvent,                       // SD
    DenonDigitalInputModeEvent,                // DC
    DenonVideoSelectModeEvent,                 // SV
    DenonSurroundModeEvent,                    // MS
    DenonHDMISettingEvent,                     // VS
    DenonAudioParameterEvent,                  // PS
    DenonPictureAdjustEvent,                   // PV
    DenonZone2Event,                           // Z2
    DenonZone3Event,                           // Z3
    DenonZone4Event,                           // Z4
    DenonAnalogRadioFrequencyEvent,            // TFAN
    DenonXMRadioFrequencyEvent,                // TFXM
    DenonHDRadioFrequencyEvent,                // TFHD******
    DenonHDRadioMulticastChannelEvent,         // TFHDM*
    DenonDABRadioFrequencyEvent,               // TFDAB
    DenonAnalogRadioPresetEvent,               // TPAN
    DenonXMRadioPresetEvent,                   // TPXM
    DenonHDRadioPresetEvent,                   // TPHD
    DenonDABRadioPresetEvent,                  // TPDAB
    DenonAnalogRadioBandOrModeEvent,           // TMAN
    DenonHDRadioBandOrModeEvent,               // TMHD
    DenonDABRadioBandOrModeEvent,              // TMDAB
    DenonRadioHDStatusEvent,                   // HD
    DenonRadioDABStatusEvent,                  // DA
    DenonRadioXMStatusEvent,                   // XM
    DenonNetUSBDisplayASCIIEvent,              // NSA
    DenonNetUSBDisplayUTF8Event,               // NSE
    DenonNSREvent,                             // NSR
    DenonNSHEvent,                             // NSH
    DenoniPodDisplayASCIIEvent,                // IPA
    DenoniPodDisplayUTF8Event,                 // IPE
    DenonLockEvent,                            // SY
    DenonSpeakerStatusEvent,                   // SSSPC
    DenonRMEvent,                              // RM
    DenonMasterVolumeMaxEvent,                 // MVM
    DenonChannelVolumeFrontLeftEvent,          // CVFL
    DenonChannelVolumeFrontRightEvent,         // CVFR
    DenonChannelVolumeCenterEvent,             // CVC
    DenonChannelVolumeSubwooferEvent,          // CVSW
    DenonChannelVolumeSurroundLeftEvent,       // CVSL
    DenonChannelVolumeSurroundRightEvent,      // CVSR
    DenonChannelVolumeSurroundBackLeftEvent,   // CVSBL
    DenonChannelVolumeSurroundBackRightEvent,  // CVSBR
    DenonChannelVolumeSurroundBackEvent,       // CVSB
};
typedef NSUInteger DenonEventType;

extern NSString * const DRHDPInputSource;
extern NSString * const DRTVCableInputSource;
extern NSString * const DRHDRadioInputSource;
extern NSString * const DRNetUSBInputSource;
extern NSString * const DRDVDInputSource;
extern NSString * const DRSatelliteInputSource;


@interface DREvent : NSObject {
@private
    NSString * _rawEvent;
    NSString * _parameter;
    DenonEventType _eventType;
}
@property (copy, readonly) NSString *rawEvent;
@property (retain) NSString *parameter;
@property (assign) DenonEventType eventType;

- (id) initWithRawEvent:(NSString *)rawEvent;

- (NSString *) stringValue;
- (BOOL) boolValue;
- (float) floatValue;
- (DRInputSource *) inputSource;

@end
