//
//  UIColor+Play_With_Pets.h
//  Play With Pets
//
//  Created by Spencer Yen on 2/18/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Play_With_Pets)

+ (instancetype)nu_colorWithHexString:(NSString *)hexString;

+ (instancetype)nu_colorWithHex:(UInt32)hex;

+ (instancetype)nu_colorWithHex:(UInt32)hex
                          alpha:(CGFloat)alpha;

#pragma mark Color Palette

+ (instancetype)nu_themeColor;
+ (instancetype)nu_themeColorWithAlpha:(CGFloat)alpha;

+ (instancetype)nu_lightGreyColor;
+ (instancetype)nu_mediumGreyColor;
+ (instancetype)nu_darkGreyColor;
+ (instancetype)nu_separatorGreyColor;
+ (instancetype)nu_facebookColor;
+ (instancetype)nu_facebookColorWithAlpha:(CGFloat)alpha;
+ (instancetype)nu_twitterColor;
+ (instancetype)nu_messengerBlueColor;
+ (instancetype)nu_googleColor;
+ (instancetype)nu_googleColorWithAlpha:(CGFloat)alpha;

@end
