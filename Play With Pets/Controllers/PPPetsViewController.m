//
//  PPPetsViewController.m
//  Play With Pets
//
//  Created by Spencer Yen on 2/18/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import "PPPetsViewController.h"
@import Firebase;

@interface PPPetsViewController () <MDCSwipeToChooseDelegate>

@property (nonatomic, retain) PPPetCardView *currentPetView;
@property (nonatomic, retain) PPPetCardView *frontPetView;
@property (nonatomic, retain) PPPetCardView *backPetView;

@property NSMutableArray *pets;
@property BOOL didFirstLoad;

@end

@implementation PPPetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showConfirmedAppointmentAlert) name:@"Confirmed Appointment" object:nil];
    
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth,
                                                    FIRUser *_Nullable user) {
        if ([PPAPIManager currentUserID]) {
            [self showLogin];
        } else {
            if (user != nil) {
                static dispatch_once_t once;
                dispatch_once(&once, ^ {
                    [PPUser getUserWithID:[[FIRAuth auth] currentUser].uid completion:^(PPUser *user) {
                        if(user) {
                            [PPAPIManager shared].currentUser = user;
                            NSLog(@"Loaded user: %@", user.id);
                            
                        }
                    }];
                });
            } else {
                [self showLogin];
                
            }
        }
    }];
    
    self.didFirstLoad = NO;
    [self fetchPets];
}

- (void) showConfirmedAppointmentAlert
{
    [[SIAlertView appearance] setTitleFont:[UIFont pp_fontNamed:PPBodyFontNameDemibold size:22.f]];
    [[SIAlertView appearance] setMessageFont:[UIFont pp_fontNamed:PPBodyFontNameRegular size:16.f]];
    [[SIAlertView appearance] setTitleColor:[UIColor blackColor]];
    [[SIAlertView appearance] setMessageColor:[UIColor blackColor]];
    [[SIAlertView appearance] setCornerRadius:10];
    [[SIAlertView appearance] setShadowRadius:20];
    [[SIAlertView appearance] setViewBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.f]];
    
    [[SIAlertView appearance] setDefaultButtonImage:[[UIImage imageFromColor:[UIColor nu_themeColor]] resizableImageWithCapInsets:UIEdgeInsetsMake(15,5,14,6)] forState:UIControlStateNormal];
    [[SIAlertView appearance] setDefaultButtonImage:[[UIImage imageFromColor:[UIColor nu_themeColorWithAlpha:0.7f]] resizableImageWithCapInsets:UIEdgeInsetsMake(15,5,14,6)] forState:UIControlStateHighlighted];
    [[SIAlertView appearance] setButtonColor:[UIColor whiteColor]];
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Great!" andMessage:@"We sent your request to the shelter. They will call you shortly to confirm logistics."];
    
    [alertView addButtonWithTitle:@"Got it!"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              
                          }];
    
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    [alertView show];
}

- (void)showLogin {
    [self performSegueWithIdentifier:@"PresentLoginVC" sender:self];
}

- (void)fetchPets {
    self.pets = [[NSMutableArray alloc] init];

    FIRDatabaseQuery *allPets = [[[FIRDatabase database] reference] child:@"pets"];
    
    [allPets observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        if(snapshot.value != [NSNull null]) {
            
            NSString *photoURL = [snapshot.value[@"photo"] stringByReplacingOccurrencesOfString:@"width=60&-pnt" withString:@"width=500&-x"];
            
            PPPet *pet = [[PPPet alloc] initWithID:snapshot.key petType:PPPetTypeDog name:snapshot.value[@"name"] sex:snapshot.value[@"sex"] age:snapshot.value[@"age"] size:snapshot.value[@"size"] breed:snapshot.value[@"breed"] bio:snapshot.value[@"description"] shelter:nil photoURLs:@[photoURL] activities:snapshot.value[@"activities"] location:snapshot.value[@"address"] email:snapshot.value[@"contact"]];
            
            if ([snapshot.value[@"animal"] isEqualToString:@"Dog"]) {
                pet.petType = PPPetTypeDog;
            } else if([snapshot.value[@"animal"] isEqualToString:@"Cat"]){
                pet.petType = PPPetTypeCat;
            }
            
            [self.pets addObject:pet];
            
            //Hacky to load the initial two pet cards
            if(self.pets.count == 2 && !self.didFirstLoad) {
                self.didFirstLoad = YES;
                
                self.frontPetView = [self popPetViewWithFrame:[self frontPetViewFrame]];
                self.backPetView = [self popPetViewWithFrame:[self backPetViewFrame]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Update UI on main thread
                    self.frontPetView.alpha = 0;
                    self.backPetView.alpha = 0;
                    [self.view addSubview:self.frontPetView];
                    [self.view sendSubviewToBack:self.frontPetView];
                    [self.view insertSubview:self.backPetView belowSubview:self.frontPetView];
                    
                    [UIView animateWithDuration:0.3f animations:^{
                        self.frontPetView.alpha = 1;
                        self.backPetView.alpha = 1;
                    }];
                });
            }
        }
    }];
    
//    PPPet *pet = [[PPPet alloc] initWithID:@"1" petType:PPPetTypeDog name:@"Pupper" age:@"5" size:@"Medium" breed:@"Dog • Boxer • Baby • Female • Medium" bio:@"I am a pupper!" shelter:nil photoURLs:@[@"https://drpem3xzef3kf.cloudfront.net/photos/pets/37443668/1/?bust=1487307367&width=632&no_scale_up=1"] activities:@"Get petted, watch TV" location:@"San Jose, CA"];
//    
//    PPPet *pet2 = [[PPPet alloc] initWithID:@"1" petType:PPPetTypeDog name:@"Doggo" age:@"5" size:@"Medium" breed:@"Dog • Boxer • Baby • Female • Medium" bio:@"I am a pupper!" shelter:nil photoURLs:@[@"http://photos.petfinder.com/photos/pets/32264590/1/?bust=1432731635&width=500&-x.jpg"] activities:@"Hiking, Catch" location:@"San Jose, CA"];
//    
//    [self.pets addObject:pet];
//    [self.pets addObject:pet2];
}

- (void)setFrontPetView:(PPPetCardView *)frontPetView {
    _frontPetView = frontPetView;
    self.currentPetView = frontPetView;
}

- (PPPetCardView *)popPetViewWithFrame:(CGRect)frame {
    if (self.pets.count == 0) {
        return nil;
    }
    
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 110.f;
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backPetViewFrame];
        self.backPetView.frame = CGRectMake(frame.origin.x,
                                            frame.origin.y - (state.thresholdRatio * 10.f),
                                            CGRectGetWidth(frame),
                                            CGRectGetHeight(frame));
    };
    options.likedText = @"Play";
    options.likedColor = [UIColor nu_themeColor];
    options.nopeText = @"Pass";
    options.nopeColor = [UIColor colorWithRed:232/255.0 green:41/255.0 blue:78/255.0 alpha:1];
    
    PPPetCardView *petView = [[PPPetCardView alloc] initWithFrame:frame pet:self.pets[0] options:options];
    [self.pets removeObjectAtIndex:0];
    return petView;
}

- (PPPetCardView *)fetchNextBackPetView {
    CGRect frame = [self backPetViewFrame];
    if (self.pets.count == 0) {
        return nil;
    }
    
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 110.f;
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backPetViewFrame];
        self.backPetView.frame = CGRectMake(frame.origin.x,
                                            frame.origin.y - (state.thresholdRatio * 10.f),
                                            CGRectGetWidth(frame),
                                            CGRectGetHeight(frame));
    };
    options.likedText = @"Play";
    options.likedColor = [UIColor nu_themeColor];
    options.nopeText = @"Pass";
    options.nopeColor = [UIColor colorWithRed:232/255.0 green:41/255.0 blue:78/255.0 alpha:1];
    PPPetCardView *petView = [[PPPetCardView alloc] initWithFrame:frame pet:self.pets[0] options:options];
    [self.pets removeObjectAtIndex:0];
    return petView;
}

- (CGRect)frontPetViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 100.f;
    CGFloat bottomPadding = 90.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - topPadding - bottomPadding);
}

- (CGRect)backPetViewFrame {
    CGRect frontFrame = [self frontPetViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y + 10.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}

#pragma mark - MDCSwipeToChooseDelegate Callbacks

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    if (direction == MDCSwipeDirectionLeft) {
        //swiped left
        NSLog(@"Photo deleted!");
    } else {
        //swiped right
        NSLog(@"Match!");
        [self showMatchScreen];
    }
    
    self.frontPetView = self.backPetView;

    if([self.pets count] > 2){
        if(!self.frontPetView) {
            self.frontPetView = [self popPetViewWithFrame:[self frontPetViewFrame]];
            self.backPetView = [self popPetViewWithFrame:[self backPetViewFrame]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //Update UI on main thread
                self.frontPetView.alpha = 0;
                self.backPetView.alpha = 0;
                [self.view addSubview:self.frontPetView];
                [self.view insertSubview:self.backPetView belowSubview:self.frontPetView];
                
                [UIView animateWithDuration:0.3f animations:^{
                    self.frontPetView.alpha = 1;
                    self.backPetView.alpha = 1;
                }];
                
            });
        } else {
            self.backPetView = [self popPetViewWithFrame:[self backPetViewFrame]];
            self.backPetView.frame = [self backPetViewFrame];
            self.backPetView.alpha = 0.f;
            [self.view insertSubview:self.backPetView belowSubview:self.frontPetView];
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.backPetView.alpha = 1.f;
                             } completion:nil];
        }
        
    } else {
        self.backPetView = nil;
    }
}

- (void) showMatchScreen
{
    PPMatchViewController *matchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"matchScreen"];
    [matchVC setupMatchScreenWithPet:self.currentPetView.pet];
    [matchVC setModalPresentationStyle:UIModalPresentationCustom];
    [matchVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:matchVC animated:YES completion:nil];
}

- (IBAction)showPlayDates:(id)sender {
    PPPlayDatesViewController *playDatesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaydatesVC"];
    [playDatesVC setModalPresentationStyle:UIModalPresentationCustom];
    [playDatesVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:playDatesVC animated:YES completion:nil];
}

@end
