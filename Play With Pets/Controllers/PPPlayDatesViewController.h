//
//  PPPlayDatesViewController.h
//  Play With Pets
//
//  Created by Spencer Yen on 2/18/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPet.h"

@interface PPPlayDatesViewController : UIViewController

@property (strong, nonatomic) PPPet *matchedPet;

@property (strong, nonatomic) IBOutlet UILabel *matchDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIImageView *matchImageView;
@property (strong, nonatomic) IBOutlet UIButton *meetButton;

- (void) setupMatchScreenWithPet:(PPPet *) pet;

@end
