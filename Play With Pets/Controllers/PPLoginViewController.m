//
//  PPLoginViewController.m
//  Play With Pets
//
//  Created by Spencer Yen on 2/18/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import "PPLoginViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface PPLoginViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *facebookLoginButton;

@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property NSString *userLocation;

@end

@implementation PPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.facebookLoginButton.layer.cornerRadius = 10.f;
    self.facebookLoginButton.layer.masksToBounds = YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    NSUInteger code = [CLLocationManager authorizationStatus];
    if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
        if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]){
            [self.locationManager requestWhenInUseAuthorization];
        } else {
            NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
        }
    }
    
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebookLoginTapped:(id)sender {
    self.facebookLoginButton.userInteractionEnabled = NO;
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile", @"email"]
                 fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                     if (error) {
                         NSLog(@"Process error");
                         self.facebookLoginButton.userInteractionEnabled = YES;
                     } else if (result.isCancelled) {
                         NSLog(@"Cancelled");
                         self.facebookLoginButton.userInteractionEnabled = YES;
                     } else {
                         [SVProgressHUD setForegroundColor:[UIColor nu_themeColor]];
                         [SVProgressHUD setBackgroundColor:[UIColor nu_colorWithHex:0xFCFCFC alpha:1.f]];
                         [SVProgressHUD setFont:[UIFont pp_fontNamed:PPBodyFontNameMedium size:18.f]];
                         [SVProgressHUD showWithStatus:@"Verifying your identity..."];
                         
                         FIRAuthCredential *credential = [FIRFacebookAuthProvider credentialWithAccessToken:[FBSDKAccessToken currentAccessToken].tokenString];
                         [[FIRAuth auth] signInWithCredential:credential
                                                   completion:^(FIRUser *user, NSError *error) {
                                                       if(!error) {
                                                       FIRUser *firUser = user;
                                                       NSString *userID = [FIRAuth auth].currentUser.uid;
                                                       
                                                        [SVProgressHUD dismiss];
                                                       
                                                       PPUser *usr = [[PPUser alloc] initWithID:userID name:firUser.displayName age:nil gender:nil photoURL:firUser.photoURL.absoluteString email:firUser.email phoneNumber:nil location:self.userLocation];
                                                       
                                                        //show pets
                                                       
                                                       [[PPAPIManager shared] createUser:usr completion:^(NSError *error) {
                                                           [self dismissViewControllerAnimated:YES completion:^{
                                                               
                                                           }];
                                                       }];
                                                       
                                                       } else {
                                                           NSLog(@"Error with singing in: %@", error);
                                                       }
                                                   }];
                     }
                 }];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    //    UIAlertView *errorAlert = [[UIAlertView alloc]
    //                 [[FLAPIManager firebaseRef] updateChildValues:nameUpdate];
    //                  initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if(!self.currentLocation) {
        self.currentLocation = newLocation;
        
        //convert to zip code, then make api call, traverse issues and check the issue ID, find the first person
        CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
        [geocoder reverseGeocodeLocation:self.currentLocation
                       completionHandler:^(NSArray *placemarks, NSError *error) {
                           if (error){
                               NSLog(@"Geocode failed with error: %@", error);
                               return;
                           }
                           CLPlacemark *placemark = [placemarks objectAtIndex:0];
                           
                           self.userLocation = [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.administrativeArea];
                           NSLog(@"got location: %@", self.userLocation);
                       }];
    }
    
}


@end
