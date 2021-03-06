//
//  ConnectionManager.h
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 21/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import <MagicalRecord/MagicalRecord.h>
#import "User.h"
#import "List+CoreDataProperties.h"

@class ConnectionManager;

@protocol ConnectionManagerDelegate <NSObject>
- (void)connectionManager:(ConnectionManager *)manager didCompleteRequestWithReturnedObjects:(NSArray *)objects;
- (void)connectionManager:(ConnectionManager *)manager didFailRequestWithError:(NSError *)error;
@end

@interface ConnectionManager : NSObject

@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) NSString *firebaseKey;

/**
 * Static getter for manager singleton shared instance
 *
 * @returns An object instance with the proper baseURL according to DEBUG/PRODUCTION
 */
+ (ConnectionManager *)defaultManager;

/**
 * Initializer for URL injection
 *
 * @param baseURL base URL for REST API
 * @returns An object instance initialized with the given base URL
 */
- (instancetype)initWithBaseURL:(NSURL *)baseURL;

- (void)requestUserCreation:(User *)user forDelegate:(id<ConnectionManagerDelegate>)delegate;
- (void)requestUserListsForDelegate:(id<ConnectionManagerDelegate>)delegate;

@end
