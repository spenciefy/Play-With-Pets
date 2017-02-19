//
//  PPPet.m
//  Play With Pets
//
//  Created by Spencer Yen on 2/18/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import "PPPet.h"

@implementation PPPet

- (id)initWithID:(NSString *)id petType:(PPPetType)petType name:(NSString *)name sex:(NSString *)sex age:(NSString *)age size:(NSString *)size breed:(NSString *)breed bio:(NSString *)bio shelter:(PPShelter *)shelter photoURLs:(NSArray *)photoURLs activities:(NSString *)activities location:(NSString *)location email:(NSString *)email {

    self = [super init];
    
    if(self) {
        self.id = id;
        self.petType = petType;
        self.name = name;
        self.age = age;
        self.sex = sex;
        self.size = size;
        self.breed = breed;
        self.bio = bio;
        self.shelter = shelter;
        self.photoURLs = photoURLs;
        self.activities = activities;
        self.location = location;
        self.email = email;
    }
    
    return self;

}

+ (NSString *)stringFromSize:(NSString *)size {
    if([size isEqualToString:@"S"]) return @"Small";
    else if([size isEqualToString:@"M"]) return @"Medium";
    else if([size isEqualToString:@"L"]) return @"Large";
    else return size;
}

+ (NSString *)stringFromSex:(NSString *)size {
    if([size isEqualToString:@"F"]) return @"Female";
    else if([size isEqualToString:@"M"]) return @"Male";
    else return size;
}

@end
