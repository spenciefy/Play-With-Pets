//
//  PPPlayDatesViewController.m
//  Play With Pets
//
//  Created by Spencer Yen on 2/19/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import "PPPlayDatesViewController.h"

@interface PPPlayDatesViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *playdates;

@end

@implementation PPPlayDatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    timeLabel.text = playdate.time;

    UIImageView *petImageView = (UIImageView *)[cell viewWithTag:101];
    petImageView.contentMode = UIViewContentModeScaleAspectFill;
    [petImageView sd_setImageWithURL:[NSURL URLWithString:playdate.pet.photoURLs[0]]];
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:102];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.text = playdate.pet.name;
    
    UILabel *descriptionLabel = (UILabel*) [cell viewWithTag:103];
    descriptionLabel.adjustsFontSizeToFitWidth = YES;
    NSString *breedString = [NSString stringWithFormat:@"%@ • %@ • %@", playdate.pet.breed, playdate.pet.age, [PPPet stringFromSize:playdate.pet.size]];
    descriptionLabel.text = breedString;
    
    UILabel *locationLabel = (UILabel*) [cell viewWithTag:104];
    locationLabel.adjustsFontSizeToFitWidth = YES;
    locationLabel.text = playdate.location;
    
    UIButton *animalShelterButton = (UIButton *)[cell viewWithTag:105];
    [animalShelterButton addTarget:self action:@selector(callShelter) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return cell;
}

- (void)callShelter {
    NSString *phNo = @"+4086218608";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
