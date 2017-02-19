//
//  PPFormViewController.m
//  Play With Pets
//
//  Created by Sachin Kesiraju on 2/19/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import "PPFormViewController.h"

@interface PPFormViewController ()
@property (strong, nonatomic) IBOutlet UITextField *activityField;
@property (strong, nonatomic) IBOutlet UITextField *timeField;
@property (strong, nonatomic) IBOutlet UITextField *locationField;

@end

@implementation PPFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.confirmButton.layer.cornerRadius = 5.0f;
    self.confirmButton.layer.masksToBounds = YES;
}

- (IBAction)confirmAppointment:(id)sender
{
    [[PPAPIManager shared] sendPlaydateRequestWithPet:self.matchedPet startTime:self.timeField.text endTime:@"" activity:self.activityField.text activityLocation:self.locationField.text];
    [[NSUserDefaults standardUserDefaults] setObject:@"Confirmed" forKey:@"Appointment"];
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
