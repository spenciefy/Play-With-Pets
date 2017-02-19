//
//  AppDelegate.m
//  Play With Pets
//
//  Created by Spencer Yen on 2/18/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import "AppDelegate.h"
@import Firebase;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [FBSDKAccessToken currentAccessToken];
    [FIRApp configure];

    return YES;
//    [[SIAlertView appearance] setTitleFont:[UIFont pp_fontNamed:PPBodyFontNameDemibold size:22.f]];
//    [[SIAlertView appearance] setMessageFont:[UIFont pp_fontNamed:PPBodyFontNameRegular size:16.f]];
//    [[SIAlertView appearance] setTitleColor:[UIColor blackColor]];
//    [[SIAlertView appearance] setMessageColor:[UIColor blackColor]];
//    [[SIAlertView appearance] setCornerRadius:10];
//    [[SIAlertView appearance] setShadowRadius:20];
//    [[SIAlertView appearance] setViewBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.f]];
//    
//    [[SIAlertView appearance] setDefaultButtonImage:[[UIImage imageFromColor:[UIColor nu_themeColor]] resizableImageWithCapInsets:UIEdgeInsetsMake(15,5,14,6)] forState:UIControlStateNormal];
//    [[SIAlertView appearance] setDefaultButtonImage:[[UIImage imageFromColor:[UIColor nu_themeColorWithAlpha:0.7f]] resizableImageWithCapInsets:UIEdgeInsetsMake(15,5,14,6)] forState:UIControlStateHighlighted];
//    [[SIAlertView appearance] setButtonColor:[UIColor whiteColor]];
//    
//    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Great!" andMessage:@"We sent your request to the shelter. They will call you shortly to confirm logistics."];
//    
//    [alertView addButtonWithTitle:@"Got it!"
//                             type:SIAlertViewButtonTypeDefault
//                          handler:^(SIAlertView *alert) {
//                              
//                          }];
//    
//    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
//    
//    [alertView show];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

@end
