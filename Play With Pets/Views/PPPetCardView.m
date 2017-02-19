//
//  PPPetCardView.m
//  Play With Pets
//
//  Created by Spencer Yen on 2/18/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import "PPPetCardView.h"

static CGFloat const MDCSwipeToChooseViewHorizontalPadding = 20.f;
static CGFloat const MDCSwipeToChooseViewTopPadding = 35.f;
static CGFloat const MDCSwipeToChooseViewLabelWidth = 65.f;

@interface PPPetCardView ()

@property (nonatomic, strong) MDCSwipeToChooseViewOptions *options;

@property UIView *containerView;
@property UIImageView *petImageView;
@property UIView *activitiesContainerView;
@property UILabel *activitiesLabel;
@property UIView *bottomContainerView;
@property UILabel *nameLabel;
@property UILabel *locationLabel;
@property UILabel *breedLabel;

@property UIView *likedView;
@property UIView *nopeView;

@property BOOL didSetupConstraints;

@end

@implementation PPPetCardView


- (instancetype)initWithFrame:(CGRect)frame
                          pet:(PPPet *)pet
                      options:(MDCSwipeToChooseViewOptions *)options {
    self = [super initWithFrame:frame];
    if (self) {
        _options = options ? options : [MDCSwipeToChooseViewOptions new];
        self.translatesAutoresizingMaskIntoConstraints = YES;

        self.pet = pet;

       // self.layer.borderWidth = 2.f;
        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.layer.shadowRadius = 5.f;
        self.layer.shadowOpacity = 0.7f;
        //self.layer.borderColor = [UIColor clearColor].CGColor;//[UIColor colorWithRed:232/255.0 green:41/255.0 blue:78/255.0 alpha:1].CGColor;
        
        self.containerView = [UIView newAutoLayoutView];
        self.containerView.layer.cornerRadius = 10.f;
        self.containerView.layer.masksToBounds = YES;
        [self addSubview:self.containerView];

        self.petImageView = [UIImageView newAutoLayoutView];
        self.petImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.petImageView sd_setImageWithURL:[NSURL URLWithString:pet.photoURLs[0]]];
        [self.containerView addSubview:self.petImageView];
        
        self.activitiesContainerView = [UIView newAutoLayoutView];
        self.activitiesContainerView.backgroundColor = [UIColor nu_themeColorWithAlpha:0.5f];
        [self.containerView addSubview:self.activitiesContainerView];
        
        self.activitiesLabel = [UILabel newAutoLayoutView];
        self.activitiesLabel.numberOfLines = 1;
        self.activitiesLabel.textAlignment = NSTextAlignmentLeft;
        self.activitiesLabel.textColor = [UIColor whiteColor];
        self.activitiesLabel.font = [UIFont pp_fontNamed:PPBodyFontNameMedium size:19.f];
        self.activitiesLabel.text = [NSString stringWithFormat:@"Activities: %@", self.pet.activities];
        [self.activitiesContainerView addSubview:self.activitiesLabel];

        self.bottomContainerView = [UIView newAutoLayoutView];
        self.bottomContainerView.backgroundColor = [UIColor whiteColor];
        [self.containerView addSubview:self.bottomContainerView];
        
        self.nameLabel = [UILabel newAutoLayoutView];
        self.nameLabel.numberOfLines = 1;
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = [UIFont pp_fontNamed:PPBodyFontNameDemibold size:25.f];
        self.nameLabel.text = self.pet.name;
        [self.bottomContainerView addSubview:self.nameLabel];
        
        self.locationLabel = [UILabel newAutoLayoutView];
        self.locationLabel.numberOfLines = 1;
        self.locationLabel.textAlignment = NSTextAlignmentRight;
        self.locationLabel.textColor = [UIColor blackColor];
        self.locationLabel.font = [UIFont pp_fontNamed:PPBodyFontNameRegular size:20.f];
        self.locationLabel.text = self.pet.location;
        [self.bottomContainerView addSubview:self.locationLabel];
        
        self.breedLabel = [UILabel newAutoLayoutView];
        self.breedLabel.numberOfLines = 1;
        self.breedLabel.textAlignment = NSTextAlignmentLeft;
        self.breedLabel.adjustsFontSizeToFitWidth = YES;
        self.breedLabel.textColor = [UIColor nu_darkGreyColor];
        self.breedLabel.font = [UIFont pp_fontNamed:PPBodyFontNameRegular size:17.f];
        NSString *breedString = [NSString stringWithFormat:@"%@ • %@ • %@", self.pet.breed, self.pet.age, [PPPet stringFromSize:self.pet.size]];
        self.breedLabel.text = breedString;
        [self.bottomContainerView addSubview:self.breedLabel];
        
        [self updateViewConstraints];
        

        dispatch_async(dispatch_get_main_queue(), ^{
            [self constructLikedView];
            [self constructNopeImageView];
            [self setupSwipeToChoose];
        });
    }
    return self;
}
- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        [self.containerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [self.petImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f) excludingEdge:ALEdgeBottom];
        [self.petImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.bottomContainerView];
        
        
        [self.activitiesContainerView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
        [self.activitiesContainerView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
        [self.activitiesContainerView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.petImageView];
        [self.activitiesContainerView autoSetDimension:ALDimensionHeight toSize:40];
        
        [self.activitiesLabel autoCenterInSuperview];
        
        [self.bottomContainerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.bottomContainerView autoSetDimension:ALDimensionHeight toSize:80.f];
        
        [self.nameLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(7.f, 15.f, 0.f, 50.f) excludingEdge:ALEdgeBottom];
        
        [self.locationLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.nameLabel];
        [self.locationLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:15.f];

        [self.breedLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:15.f];
        [self.breedLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:15.f];
        [self.breedLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel withOffset:1.f];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (void)constructLikedView {
    
    CGRect frame = CGRectMake(MDCSwipeToChooseViewHorizontalPadding,
                              MDCSwipeToChooseViewTopPadding,
                              CGRectGetMidX(self.bounds),
                              MDCSwipeToChooseViewLabelWidth);
    self.likedView = [[UIView alloc] initWithFrame:frame];
    [self.likedView constructBorderedLabelWithText:self.options.likedText
                                             color:self.options.likedColor
                                             angle:self.options.likedRotationAngle];
    self.likedView.alpha = 0.f;
    [self addSubview:self.likedView];
}

- (void)constructNopeImageView {
    CGFloat width = CGRectGetMidX(self.bounds);
    CGFloat xOrigin = CGRectGetMaxX(self.bounds) - width - MDCSwipeToChooseViewHorizontalPadding;
    self.nopeView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin,
                                                                  MDCSwipeToChooseViewTopPadding,
                                                                  width,
                                                                  MDCSwipeToChooseViewLabelWidth)];
    [self.nopeView constructBorderedLabelWithText:self.options.nopeText
                                            color:self.options.nopeColor
                                            angle:self.options.nopeRotationAngle];
    self.nopeView.alpha = 0.f;
    [self addSubview:self.nopeView];
}

- (void)setupSwipeToChoose {
    MDCSwipeOptions *options = [MDCSwipeOptions new];
    options.delegate = self.options.delegate;
    options.threshold = self.options.threshold;
    
    __block UIView *likedImageView = self.likedView;
    __block UIView *nopeImageView = self.nopeView;
    __weak PPPetCardView *weakself = self;
    options.onPan = ^(MDCPanState *state) {
        if (state.direction == MDCSwipeDirectionNone) {
            likedImageView.alpha = 0.f;
            nopeImageView.alpha = 0.f;
        } else if (state.direction == MDCSwipeDirectionLeft) {
            likedImageView.alpha = 0.f;
            nopeImageView.alpha = state.thresholdRatio;
        } else if (state.direction == MDCSwipeDirectionRight) {
            likedImageView.alpha = state.thresholdRatio;
            nopeImageView.alpha = 0.f;
        }
        
        if (weakself.options.onPan) {
            weakself.options.onPan(state);
        }
    };
    
    [self mdc_swipeToChooseSetup:options];
}

@end
