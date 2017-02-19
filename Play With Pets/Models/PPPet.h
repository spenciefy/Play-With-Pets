//
//  PPPet.h
//  Play With Pets
//
//  Created by Spencer Yen on 2/18/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PPShelter;

typedef NS_ENUM(NSInteger, PPPetType) {
    PPPetTypeDog,
    PPPetTypeCat
};

@interface PPPet : NSObject

@property NSString *id;
@property PPPetType petType;
@property NSString *name;
@property NSString *sex;
@property NSString *age;
@property NSString *size;
@property NSString *breed;
@property NSString *bio;
@property PPShelter *shelter;
@property NSArray *photoURLs;
@property NSString *activities;
@property NSString *location;

- (id)initWithID:(NSString *)id petType:(PPPetType)petType name:(NSString *)name sex:(NSString *)sex age:(NSString *)age size:(NSString *)size breed:(NSString *)breed bio:(NSString *)bio shelter:(PPShelter *)shelter photoURLs:(NSArray *)photoURLs activities:(NSString *)activities location:(NSString *)location;

+ (NSString *)stringFromSex:(NSString *)size;
+ (NSString *)stringFromSize:(NSString *)size;

@end
