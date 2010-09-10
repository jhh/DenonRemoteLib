# DenonRemoteLib

A Mac iOS and OSX library for interacting with the Denon AVR-4308CI receiver via the telnet network protocol.

## Adding DenonRemoteLib to your project

DenonRemoteLib's Objective-C classes can be easily added to your projects. Here's how:

1. Clone the DenonRemoteLib git repository: `git clone git://github.com/jhh/DenonRemoteLib`. Make sure you locate the repository where Xcode can find it every time you compile your project.
2. Locate the "Classes" folder in "DenonRemoteLib" and drag and drop it onto the root of your Xcode project "Groups & Files" sidebar.  A dialog will appear -- make sure "Copy items" is unchecked, "Reference Type" is "Relative to Project" and your target is selected under "Add to Targets" before clicking "Add".
3. Optionally, renamed the new "Classes" group to something else, i.e. "DenonRemoteLib".

## Using DenonRemoteLib

For a working command-line example see [DenonTool](http://github.com/jhh/DenonTool).

### Classes

[DREvent](http://github.com/jhh/DenonRemoteLib/blob/master/Classes/DREvent.h "Classes/DREvent.h at master from jhh's DenonRemoteLib - GitHub") encapsulates state changes or status updates from the receiver.

[DRInputSource](http://github.com/jhh/DenonRemoteLib/blob/master/Classes/DRInputSource.h "Classes/DRInputSource.h at master from jhh's DenonRemoteLib - GitHub") encapsulates the input sources of the receiver. It contains properties for the standard name of the source that it used to switch sources and the user-customized name of the source.

[DRSession](http://github.com/jhh/DenonRemoteLib/blob/master/Classes/DRSession.h "Classes/DRSession.h at master from jhh's DenonRemoteLib - GitHub") is a connected session with the receiver. Methods on this class send commands and receive updates. This class required a run loop to be running.

[DRSession+Commands](http://github.com/jhh/DenonRemoteLib/blob/master/Classes/DRSession%2BCommands.h "Classes/DRSession+Commands.h at master from jhh's DenonRemoteLib - GitHub") contains convenient methods to request status from and send commands to the receiver.

### Example

    #import "DRSession+Commands.h"
    #import "DREvent.h"
    
    @interface Example : NSObject <DRSessionDelegate> {
        DRSession * session;
    }
    
    @implementation Example
    
    - (id) init {
        if ((self = [super init])) {
            session = [[DRSession alloc] initWithHostName:@"10.1.2.3"];
            [session setDelegate:self];
			
            // send command
            [session sendPower:DROnState];
            // use runloop timer to allow receiver to respond between successive commands
            [session performSelector:@selector(queryMasterVolume)
                          withObject:nil afterDelay:0.5];
        }
        return self;
    }
    
    // DRSessionDelegate callback methods
    
    - (void) session:(DRSession *)aSession didReceiveEvent:(DREvent *)event {
        switch (event.eventType) {
            case DenonPowerEvent:
                // [event boolValue] == YES if receiver power is on
                break;
            case DenonMasterVolumeEvent:
                // [event floatValue] returns receiver volume
                break;
            // etc...
            default:
                // unexpected event
        }
    }

    - (void) session:(DRSession *)aSession didFailWithError:(NSError *)error {
        // handle error
    }

## License

DenonRemoteLib is published under the Apache License, see the LICENSE file.