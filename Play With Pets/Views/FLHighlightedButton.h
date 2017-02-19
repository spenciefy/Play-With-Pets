//
//  FLHighlightedButton.h
//  Flutter
//
//  Created by Spencer Yen on 6/30/16.
//  Copyright © 2016 Flutter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLHighlightedButton;

@protocol FLHighlightedButtonDelegate <NSObject>

- (void)highlightedButtonHighlightedChanged:(FLHighlightedButton *)button;

@end

@interface FLHighlightedButton : UIButton

@property (weak, nonatomic) id<FLHighlightedButtonDelegate> delegate;

@property (nonatomic) UIColor *defaultColor;
@property UIColor *highlightedColor;
@property BOOL disabledShouldSetColor;

@end