//
//  PPPlayDatesViewController.m
//  Play With Pets
//
//  Created by Spencer Yen on 2/19/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import "PPPlayDatesViewController.h"
#import <MessageUI/MessageUI.h>

@interface PPPlayDatesViewController () <UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *playdates;
@property (weak, nonatomic) IBOutlet BTNDropinButton *uberDropinButton;

@end

@implementation PPPlayDatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.uberDropinButton.buttonId = @"btn-48a9c24adf3613c6";
    
    // Set up your context.
    BTNLocation *subjectLocation = [BTNLocation locationWithName:@"Home" latitude:[[PPAPIManager shared].currentUser.lat floatValue] longitude:[[PPAPIManager shared].currentUser.lng floatValue]];
    BTNContext *context = [BTNContext contextWithSubjectLocation:subjectLocation];
    
    [self.uberDropinButton prepareWithContext:context completion:^(BOOL isDisplayable) {
        NSLog(@"Displayable: %@", @(isDisplayable));
    }];
    
    [self loadPlayDates];
    
}

- (void)loadPlayDates {
    self.playdates = [[NSMutableArray alloc] init];
    
    FIRDatabaseQuery *playdates = [[PPAPIManager firebaseRef] child:@"requests"];
    
    [playdates observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        if(snapshot.value != [NSNull null]) {
            [self.playdates addObject:[PPPlayDate playdateFromFirebaseDictionary:snapshot.value id:snapshot.key]]
            ;

            [self.tableView reloadData];
        }
    }];
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NUAnnouncement *announcement = self.announcements[indexPath.row];
//
//    CGSize constrain = CGSizeMake(self.view.frame.size.width - 125 , FLT_MAX);
//    CGSize size = [announcement.body sizeWithFont:[UIFont nu_fontNamed:NUBodyFontNameRegular size:17.f] constrainedToSize:constrain lineBreakMode:NSLineBreakByWordWrapping];
//
//    //    CGRect paragraphRect =
//    //    [attributedText boundingRectWithSize:CGSizeMake(300.f, CGFLOAT_MAX)
//    //                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
//    //                                 context:nil];
//    if(size.height + 20.f > 66.f) {
//        return size.height + 20.f;
//    } else {
//        return 65.f;
//    }
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.playdates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PlayDateCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    PPPlayDate *playdate = [self.playdates objectAtIndex:indexPath.row];

    UILabel *timeLabel = (UILabel*) [cell viewWithTag:100];
    timeLabel.adjustsFontSizeToFitWidth = YES;
    timeLabel.text = [NSString stringWithFormat:@"%@", playdate.time];

    UIImageView *petImageView = (UIImageView *)[cell viewWithTag:101];
    petImageView.layer.masksToBounds = YES;
    petImageView.contentMode = UIViewContentModeScaleAspectFill;
    [petImageView sd_setImageWithURL:[NSURL URLWithString:playdate.pet.photoURLs[0]]];
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:102];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.text = playdate.pet.name;
    
    UILabel *descriptionLabel = (UILabel*) [cell viewWithTag:103];
    descriptionLabel.adjustsFontSizeToFitWidth = YES;
    NSString *breedString = [NSString stringWithFormat:@"%@ • %@ • %@", playdate.pet.breed, playdate.pet.age, [PPPet stringFromSize:playdate.pet.size]];
    descriptionLabel.text = @"San Jose, CA";
    
    UILabel *locationLabel = (UILabel*) [cell viewWithTag:104];
    locationLabel.adjustsFontSizeToFitWidth = YES;
    locationLabel.text = playdate.status;
    
    UIButton *animalShelterButton = (UIButton *)[cell viewWithTag:105];
    [animalShelterButton addTarget:self action:@selector(callShelter) forControlEvents:UIControlEventTouchUpInside];
    UIButton *emailButton = (UIButton *)[cell viewWithTag:106];
    [emailButton addTarget:self action:@selector(emailShelter) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (void)callShelter {
    NSString *phNo = @"+6503671405";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
}

- (void)emailShelter {

    NSString *emailTitle = @"Feedback for Pet";
    NSString *messageBody = @"Hi,\n\n";
    NSArray *toRecipents = [NSArray arrayWithObject:@"contact@petscare.org"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    //    [mc.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor et_greenThemeColor] forKey:NSForegroundColorAttributeName]];
    [mc.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self presentViewController:mc animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
