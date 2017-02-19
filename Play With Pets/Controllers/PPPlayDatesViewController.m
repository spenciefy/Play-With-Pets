//
//  PPPlayDatesViewController.m
//  Play With Pets
//
//  Created by Spencer Yen on 2/18/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import "PPPlayDatesViewController.h"

@interface PPPlayDatesViewController ()

@end

@implementation PPPlayDatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //blur background
    self.view.backgroundColor = [UIColor clearColor];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:blurEffectView atIndex:0];
    
    //update ui
    self.matchDescriptionLabel.text = [NSString stringWithFormat:@"You and %@ are perfect for each other!", self.matchedPet.name];
    [self.matchImageView sd_setImageWithURL:[NSURL URLWithString:self.matchedPet.photoURLs[0]]];
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.borderWidth = 1.5f;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.matchImageView.layer.cornerRadius = self.matchImageView.frame.size.width/2;
    self.matchImageView.layer.masksToBounds = YES;
    self.matchImageView.layer.borderWidth = 1.5f;
    self.matchImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.meetButton.layer.cornerRadius = 5.0f;
    self.meetButton.layer.masksToBounds = YES;
}

- (IBAction)contactMatch:(id)sender
{
    
}

- (void) setupMatchScreenWithPet:(PPPet *) pet
{
    self.matchedPet = pet;
    [self.profileImageView setImage:[UIImage imageNamed:@"me.png"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
