//
//  NSArray+findObject.h
//  CardLove-v1
//
//  Created by FOLY on 5/23/13.
//  Copyright (c) 2013 FOLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (findObject)

-(BOOL) hasObjectWithKey:(NSString *)key andValue:(NSString *)value;
-(id) findObjectWithKey:(NSString *)key andValue:(NSString *)value;
@end
