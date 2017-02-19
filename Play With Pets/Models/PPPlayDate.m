//
//  PPPlayDate.m
//  Play With Pets
//
//  Created by Spencer Yen on 2/19/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import "PPPlayDate.h"

@implementation PPPlayDate

- (id)initWithID:(NSString *)id pet:(PPPet *)pet status:(NSString *)status time:(NSString *)time activity:(NSString *)activity location:(NSString *)location shelterPhoneNumber:(NSString *)shelterPhoneNumber shelterName:(NSString *)shelterName {
    self = [super init];
    
    if(self) {
        self.id = id;
        self.pet = pet;
        self.status = status;
        self.time = time;
        self.activity = activity;
        self.location = location;
        self.shelterPhoneNumber = shelterPhoneNumber;
        self.shelterName = shelterName;
    }
    
    return self;

}

+ (PPPlayDate *)playdateFromFirebaseDictionary:(NSDictionary *)playdateDict id:(NSString *)id {
    if(playdateDict) {
        //NSDate *date = [NSDate dateWithTimeIntervalSince1970:[playdateDict[@"time"] doubleValue]];
#warning doesnt actualy get real pet here
        PPPet *pet = [[PPPet alloc] initWithID:playdateDict[@"pet_id"] petType:PPPetTypeDog name:playdateDict[@"pet_name"] sex:@"M" age:@"Y" size:@"L" breed:@"breed" bio:@"" shelter:nil photoURLs:@[playdateDict[@"pet_image"]] activities:nil location:playdateDict[@"pet_location"] email:playdateDict[@"pet_email"]];
        
        if(playdateDict[@"start_time"]) {
        return [[PPPlayDate alloc] initWithID:id pet:pet status:playdateDict[@"status"] time:playdateDict[@"start_time"] activity:playdateDict[@"activity"] location:playdateDict[@"activity_location"] shelterPhoneNumber:@"4089128321" shelterName:@"SHELTER NAME"];
        } else{
        return [[PPPlayDate alloc] initWithID:id pet:pet status:playdateDict[@"status"] time:@"Sunday, 2/19 3-7PM" activity:playdateDict[@"activity"] location:playdateDict[@"activity_location"] shelterPhoneNumber:@"4089128321" shelterName:@"SHELTER NAME"];
        }
        
    }
    return nil;
}
@end
