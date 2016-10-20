//
//  AlertControllerFactory.h
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 19/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertControllerFactory : NSObject

+ (UIAlertController *)textFieldAlertControllerWithTitle:(NSString *)title
                                                 andText:(NSString *)text
                                          andPlaceHolder:(NSString *)placeHolder
                                              actionName:(NSString *)actionName
                                       completionHandler:(void (^)(NSString *text))completionHandler;

+ (UIAlertController *)deleteAlertControllerWithTitle:(NSString *)title
                                           andMessage:(NSString *)message
                                      deletionHandler:(void (^)())deletionHandler
                                        cancelHandler:(void (^)())cancelHandler;

@end
