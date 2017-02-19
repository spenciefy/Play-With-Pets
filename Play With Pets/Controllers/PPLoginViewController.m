//
//  PPLoginViewController.m
//  Play With Pets
//
//  Created by Spencer Yen on 2/18/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import "PPLoginViewController.h"

@interface PPLoginViewController ()

@property (strong, nonatomic) IBOutlet UIButton *facebookLoginButton;

@end

@implementation PPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.facebookLoginButton.layer.cornerRadius = 10.f;
    self.facebookLoginButton.layer.masksToBounds = YES;
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
                                                       
                                                       PPUser *usr = [[PPUser alloc] initWithID:userID name:firUser.displayName age:nil gender:nil photoURL:firUser.photoURL.absoluteString email:firUser.email phoneNumber:nil location:nil];
                                                       
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


@end
