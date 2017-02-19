//
//  PPPetCardView.h
//  Play With Pets
//
//  Created by Spencer Yen on 2/18/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDCSwipeToChooseViewOptions;
@class PPPet;

@interface PPPetCardView : UIView

@property PPPet *pet;



- (instancetype)initWithFrame:(CGRect)frame
                          pet:(PPPet *)pet
                      options:(MDCSwipeToChooseViewOptions *)options;


@end
