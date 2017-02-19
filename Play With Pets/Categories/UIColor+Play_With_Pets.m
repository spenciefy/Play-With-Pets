//
//  UIColor+Play_With_Pets.m
//  Play With Pets
//
//  Created by Spencer Yen on 2/18/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import "UIColor+Play_With_Pets.h"

@implementation UIColor (Play_With_Pets)

+ (instancetype)nu_colorWithHexString:(NSString *)hexString
{
    unsigned int hex = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&hex];
    return [self nu_colorWithHex:hex];
}

+ (instancetype)nu_colorWithHex:(UInt32)hex
{
    return [[self class] nu_colorWithHex:hex alpha:1.f];
}

+ (instancetype)nu_colorWithHex:(UInt32)hex alpha:(CGFloat)alpha
{
    return [[self class] colorWithRed:((hex >> 16) & 0xFF) / 255.f
                                green:((hex >>  8) & 0xFF) / 255.f
                                 blue:(hex         & 0xFF) / 255.f
                                alpha:alpha];
}

#pragma mark Color Palette

+ (instancetype)nu_themeColor
{
    return [[self class] nu_colorWithHex:0xd663f9];
}

+ (instancetype)nu_themeColorWithAlpha:(CGFloat)alpha
{
    return [[self class] nu_colorWithHex:0xd663f9 alpha:alpha];
}

+ (instancetype)nu_lightGreyColor {
    return [[self class] nu_colorWithHex:0xF0F0F0 alpha:1.0];
}

+ (instancetype)nu_mediumGreyColor {
    return [[self class] nu_colorWithHex:0xB2B2B2];
}

+ (instancetype)nu_darkGreyColor
{
    return [[self class] nu_colorWithHex:0x7F7F7F];
}

+ (instancetype)nu_separatorGreyColor
{
    return [[self class] nu_colorWithHex:0xE5E5E5];
}

+ (instancetype)nu_facebookColor
{
    return [[self class] nu_colorWithHex:0x5B81D1];
}

+ (instancetype)nu_facebookColorWithAlpha:(CGFloat)alpha
{
    return [[self class] nu_colorWithHex:0x5B81D1 alpha:alpha];
}

+ (instancetype)nu_googleColor
{
    return [[self class] nu_colorWithHex:0xF44336];
}

+ (instancetype)nu_googleColorWithAlpha:(CGFloat)alpha
{
    return [[self class] nu_colorWithHex:0xF44336 alpha:alpha];
}

+ (instancetype)nu_twitterColor
{
    return [[self class] nu_colorWithHex:0x55ACEE];
}

+ (instancetype)nu_messengerBlueColor
{
    return [[self class] nu_colorWithHex:0x0084FF];
}

@end
