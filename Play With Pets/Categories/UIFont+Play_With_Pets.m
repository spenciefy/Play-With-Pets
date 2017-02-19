//
//  UIFont+Play_With_Pets.m
//  Play With Pets
//
//  Created by Spencer Yen on 2/18/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import "UIFont+Play_With_Pets.h"

@implementation UIFont (Play_With_Pets)

+ (instancetype)pp_fontNamed:(PPFontName)fontName
                        size:(CGFloat)size
{
    UIFont *font;
    
    switch (fontName) {
        case PPHeadingFontNameRegular: {
            font = [UIFont fontWithName:@"AvenirNext-Regular" size:size];
            break;
        }
        case PPHeadingFontNameSemibold: {
            font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:size];
            break;
        }
        case PPBodyFontNameRegular: {
            font = [UIFont fontWithName:@"AvenirNext-Regular" size:size];
            break;
        }
        case PPBodyFontNameDemibold: {
            font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:size];
            break;
        }
        case PPBodyFontNameMedium: {
            font = [UIFont fontWithName:@"AvenirNext-Medium" size:size];
            break;
        }
    }
    return font;
}

@end
