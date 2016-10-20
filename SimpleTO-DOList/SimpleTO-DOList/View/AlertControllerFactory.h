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
                                          andPlaceHolder:(NSString *)placeHolder
                                       completionHandler:(void (^)(NSString *text))completionHandler;

@end
