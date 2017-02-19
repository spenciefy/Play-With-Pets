//
//  PPFormViewController.h
//  Play With Pets
//
//  Created by Sachin Kesiraju on 2/19/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPFormViewController : UIViewController

@property (strong, nonatomic) PPPet *matchedPet;

@property (strong, nonatomic) IBOutlet UIButton *confirmButton;

@end
