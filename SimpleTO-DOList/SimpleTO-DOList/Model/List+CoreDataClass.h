//
//  List+CoreDataClass.h
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 19/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import <MagicalRecord/MagicalRecord.h>
#import <RestKit/RestKit.h>

@class Item;

NS_ASSUME_NONNULL_BEGIN

@interface List : NSManagedObject

/**
 * Mapping object for json attributes into object properties
 *
 * @returns RKObjectMapping object
 */
+ (RKEntityMapping *)responseMapping;

@end

NS_ASSUME_NONNULL_END

#import "List+CoreDataProperties.h"
