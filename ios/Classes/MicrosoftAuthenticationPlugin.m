#import "MicrosoftAuthenticationPlugin.h"
#if __has_include(<microsoft_authentication/microsoft_authentication-Swift.h>)
#import <microsoft_authentication/microsoft_authentication-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "microsoft_authentication-Swift.h"
#endif

@implementation MicrosoftAuthenticationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMicrosoftAuthenticationPlugin registerWithRegistrar:registrar];
}
@end
