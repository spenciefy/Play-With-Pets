//
//  FLHighlightedButton.m
//  Flutter
//
//  Created by Spencer Yen on 6/30/16.
//  Copyright © 2016 Flutter. All rights reserved.
//

#import "FLHighlightedButton.h"

@implementation FLHighlightedButton

- (id)init
{
    self = [super init];
    
    if (self) {
        self.defaultColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = self.highlightedColor ? self.highlightedColor : self.defaultColor;
    } else {
        self.backgroundColor = self.defaultColor;
    }
    
    if ([self.delegate respondsToSelector:@selector(highlightedButtonHighlightedChanged:)]) {
        [self.delegate highlightedButtonHighlightedChanged:self];
    }
}

- (void)setDefaultColor:(UIColor *)defaultColor
{
    _defaultColor = defaultColor;
    self.backgroundColor = defaultColor;
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if (!enabled && self.disabledShouldSetColor) {
        self.backgroundColor = self.highlightedColor ? self.highlightedColor : self.defaultColor;
    } else {
        self.backgroundColor = self.defaultColor;
    }
}

@end

