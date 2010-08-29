//
//  DRRemoteEvent.h
//  DenonEngine
//
//  Created by Jeff Hutchison on 3/28/10.
//  Copyright 2010 Jeffrey Hutchison. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
  DenonUnknownEvent,
  DenonPowerEvent,                           // PW
  DenonMasterVolumeEvent,                    // MV
  DenonMuteEvent,                            // MU
  DenonInputSourceEvent,                     // SI
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
  DenonSSEvent,                              // SS
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
  NSString *rawEvent_;
  NSString *parameter_;
  DenonEventType eventType_;    
}
@property (copy, readonly) NSString *rawEvent;
@property (retain) NSString *parameter;
@property (assign) DenonEventType eventType;

- (id)initWithEvent:(NSString *)rawEvent;

- (NSString *)stringValue;
- (BOOL)boolValue;
- (float)floatValue;

@end
