//
//  UIFont+Play_With_Pets.h
//  Play With Pets
//
//  Created by Spencer Yen on 2/18/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PPFontName) {
    PPHeadingFontNameRegular,
    PPHeadingFontNameSemibold,
    PPBodyFontNameRegular,
    PPBodyFontNameMedium,
    PPBodyFontNameDemibold
};

@interface UIFont (Play_With_Pets)

+ (instancetype)pp_fontNamed:(PPFontName)fontName
                        size:(CGFloat)size;

@end

