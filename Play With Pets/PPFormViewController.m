//
//  PPFormViewController.m
//  Play With Pets
//
//  Created by Sachin Kesiraju on 2/19/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import "PPFormViewController.h"

@interface PPFormViewController ()

@end

@implementation PPFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.confirmButton.layer.cornerRadius = 5.0f;
    self.confirmButton.layer.masksToBounds = YES;
}

- (IBAction)confirmAppointment:(id)sender
{
    [[PPAPIManager shared] sendPlaydateRequestWithPet:self.matchedPet startTime:@"Sunday, 2/18 11:00 AM" endTime:@"Sunday, 2/18 3:00 PM" activity:@"Hike" activityLocation:@"Stanford Dish"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Confimed" forKey:@"Appointment"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissModalStack];
}

-(void)dismissModalStack {
    UIViewController *vc = self.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Confirmed Appointment" object:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
