# DenonRemoteLib

A Mac iOS and OSX library for interacting with the Denon AVR-4308CI receiver via the telnet network protocol.

## Adding DenonRemoteLib to your project

DenonRemoteLib's Objective-C classes can be easily added to your projects. Here's how:

1. Clone the DenonRemoteLib git repository: `git clone git://github.com/jhh/DenonRemoteLib`. Make sure you locate the repository where Xcode can find it every time you compile your project.
2. Locate the "Classes" folder in "DenonRemoteLib" and drag and drop it onto the root of your Xcode project "Groups & Files" sidebar.  A dialog will appear -- make sure "Copy items" is unchecked, "Reference Type" is "Relative to Project" and your target is selected under "Add to Targets" before clicking "Add".
3. Optionally, renamed the new "Classes" group to something else, i.e. "DenonRemoteLib".

## Using DenonRemoteLib

[DREvent](http://github.com/jhh/DenonRemoteLib/blob/master/Classes/DREvent.h "Classes/DREvent.h at master from jhh's DenonRemoteLib - GitHub") encapsulates state changes or status updates from the receiver.

[DRSession](http://github.com/jhh/DenonRemoteLib/blob/master/Classes/DRSession.h "Classes/DRSession.h at master from jhh's DenonRemoteLib - GitHub") is a connected session with the receiver. Methods on this class send commands and receive updates.

[DRSession+Commands](http://github.com/jhh/DenonRemoteLib/blob/master/Classes/DRSession%2BCommands.h "Classes/DRSession+Commands.h at master from jhh's DenonRemoteLib - GitHub") contains convenient methods to request status from and send commands to the receiver.