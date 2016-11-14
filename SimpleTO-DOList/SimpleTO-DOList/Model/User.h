//
//  User.h
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 21/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import <RestKit/RestKit.h>

@interface User : NSObject

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *firebaseKey;

/**
 * Mapping object for object properties into json attributes
 *
 * @returns RKObjectMapping object
 */
+ (RKObjectMapping *)requestMapping;

/**
 * Mapping object for json attributes into object properties
 *
 * @returns RKObjectMapping object
 */
+ (RKObjectMapping *)responseMapping;

@end
