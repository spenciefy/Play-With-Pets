//
//  NSObject+Play_With_Pets.m
//  Play With Pets
//
//  Created by Spencer Yen on 2/18/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import "NSObject+Play_With_Pets.h"
#import <objc/message.h>
#import <objc/runtime.h>

static void * kPMKPromiseStore = &kPMKPromiseStore;

@interface PMKPromiseResolver : NSObject

@property (strong) PMKPromiseFulfiller fulfiller;
@property (strong) PMKPromiseRejecter rejecter;

+ (PMKPromiseResolver *)resolverWithFulfiller:(PMKPromiseFulfiller)fulfiller
                                     rejecter:(PMKPromiseRejecter)rejecter;

@end

@implementation PMKPromiseResolver

+ (instancetype)resolverWithFulfiller:(PMKPromiseFulfiller)fulfiller
                             rejecter:(PMKPromiseRejecter)rejecter
{
    PMKPromiseResolver *resolver = [[self alloc] init];
    resolver.fulfiller = fulfiller;
    resolver.rejecter = rejecter;
    return resolver;
}

@end

@implementation NSObject (Play_With_Pets)

- (NSDictionary *)dictionaryRepresentation {
    unsigned int count = 0;
    // Get a list of all properties in the class.
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSString *value = [self valueForKey:key];
        
        if([value isKindOfClass:[NSArray class]]) {
            NSArray *valueArray = (NSArray *)value;
            NSMutableArray *valueArrayInDictionary = [[NSMutableArray alloc] init];
            for(id value in valueArray) {
                if([value isKindOfClass:[NSString class]]) {
                    [valueArrayInDictionary addObject:value];
                }
            }
            [dictionary setObject:valueArrayInDictionary forKey:key];
        } else if([value isKindOfClass:[NSDictionary class]]) {
            [dictionary setObject:value forKey:key];
        } else if([value isKindOfClass:[NSDate class]]) {
            NSDate *date = (NSDate *)value;
            // note that dates are being stored as timeIntervalSince1970
            [dictionary setObject:[NSNumber numberWithDouble:[date timeIntervalSince1970]] forKey:key];
        } else if (value) {
            // Only add to the NSDictionary if it's not nil.
            [dictionary setObject:value forKey:key];
        }
    }
    
    free(properties);
    
    return dictionary;
}

- (NSMutableDictionary *)promiseStore
{
    NSMutableDictionary *store = objc_getAssociatedObject(self, kPMKPromiseStore);
    if (!store) {
        store = [NSMutableDictionary new];
        objc_setAssociatedObject(self, kPMKPromiseStore, store, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return store;
}

- (PMKPromise *)promiseForKey:(NSString *)key
{
    return [[self promiseStore] objectForKey:key];
}

- (PMKPromise *)newPromiseForKey:(NSString *)key
{
    if (![[self promiseStore] objectForKey:key]) {
        return [PMKPromise new:^(id fulfiller, id rejecter) {
            PMKPromiseResolver *resolver = [PMKPromiseResolver resolverWithFulfiller:fulfiller
                                                                            rejecter:rejecter];
            [[self promiseStore] setObject:resolver
                                    forKey:key];
        }];
    } else {
        @throw [NSString stringWithFormat:@"Promise already exists for key %@", key];
    }
}

- (void)fulfill:(id)result
         forKey:(NSString *)key
{
    PMKPromiseResolver *resolver = [[self promiseStore] objectForKey:key];
    if (resolver) {
        if (resolver.fulfiller)
            resolver.fulfiller(result);
        [[self promiseStore] removeObjectForKey:key];
    } else {
        @throw [NSString stringWithFormat:@"No unresolved promise for key %@", key];
    }
}

- (void)reject:(NSError *)error
        forKey:(NSString *)key
{
    PMKPromiseResolver *resolver = [[self promiseStore] objectForKey:key];
    if (resolver) {
        if (resolver.rejecter)
            resolver.rejecter(error);
        [[self promiseStore] removeObjectForKey:key];
    } else {
        @throw [NSString stringWithFormat:@"No unresolved promise for key %@", key];
    }
}

- (BOOL)hasPromise
{
    return objc_getAssociatedObject(self, @selector(fulfill:)) && objc_getAssociatedObject(self, @selector(reject:));
}

- (PMKPromise *)promise
{
    return [PMKPromise new:^(PMKFulfiller fulfiller, PMKRejecter rejecter) {
        objc_setAssociatedObject(self, @selector(fulfill:), fulfiller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, @selector(reject:), rejecter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }];
}

- (void)fulfill:(id)result
{
    void (^fulfiller)(id) = objc_getAssociatedObject(self, _cmd);
    objc_setAssociatedObject(self, @selector(fulfill:), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @selector(reject:), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    fulfiller(result);
}

- (void)reject:(NSError *)error
{
    void (^rejecter)(id) = objc_getAssociatedObject(self, _cmd);
    objc_setAssociatedObject(self, @selector(fulfill:), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @selector(reject:), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    rejecter(error);
}

@end
