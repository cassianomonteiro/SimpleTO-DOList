//
//  Item+CoreDataClass.h
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 19/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class List;

NS_ASSUME_NONNULL_BEGIN

@interface Item : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Item+CoreDataProperties.h"
