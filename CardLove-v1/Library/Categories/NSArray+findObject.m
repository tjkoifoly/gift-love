//
//  NSArray+findObject.m
//  CardLove-v1
//
//  Created by FOLY on 5/23/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import "NSArray+findObject.h"

@implementation NSArray (findObject)

-(BOOL) hasObjectWithKey:(NSString *)key andValue:(NSString *)value
{
    NSPredicate *predExists = [NSPredicate predicateWithFormat:
                               @"%K MATCHES[c] %@", key, value];
    NSUInteger index = [self indexOfObjectPassingTest:
                        ^(id obj, NSUInteger idx, BOOL *stop) {
                            return [predExists evaluateWithObject:obj];
                        }];
    
    if (index == NSNotFound) {
        return NO;
    }
    
    return YES;
}

-(id) findObjectWithKey:(NSString *)key andValue:(NSString *)value
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", key , value];
    NSMutableArray *result = [NSMutableArray arrayWithArray:self];
    [result filterUsingPredicate:predicate];
    
    if ([result count] == 0) {
        return nil;
    }
    return [result objectAtIndex:0];
}

@end
