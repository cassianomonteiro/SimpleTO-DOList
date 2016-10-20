//
//  AlertControllerFactory.m
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 19/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import "AlertControllerFactory.h"

@implementation AlertControllerFactory

+ (UIAlertController *)textFieldAlertControllerWithTitle:(NSString *)title andText:(NSString *)text andPlaceHolder:(NSString *)placeHolder actionName:(NSString *)actionName completionHandler:(void (^)(NSString *))completionHandler
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    // Keep reference to the textFieldObserver, to remove it on alert dismissal
    id __block textFieldObserver;
    
    UIAlertAction *createAction = [UIAlertAction actionWithTitle:actionName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // Remove observer to void memory leaks
        [[NSNotificationCenter defaultCenter] removeObserver:textFieldObserver];
        
        // Perform completion handler on typed text
        UITextField *textField = alertController.textFields.firstObject;
        completionHandler(textField.text);
    }];
    // Start action disabled while textfield is empty
    createAction.enabled = (text && text.length > 0);
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = text?:@"";
        textField.placeholder = placeHolder;
    
        // Add observer to enable action when textfield has some text.
        // Keep reference to the textFieldObserver, to remove it on alert dismissal
        textFieldObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:textField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            createAction.enabled = ![textField.text isEqualToString:@""];
        }];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // Remove observer to void memory leaks
        [[NSNotificationCenter defaultCenter] removeObserver:textFieldObserver];
    }];
    
    [alertController addAction:createAction];
    [alertController addAction:cancelAction];
    
    return alertController;
}

+ (UIAlertController *)deleteAlertControllerWithTitle:(NSString *)title andMessage:(NSString *)message deletionHandler:(void (^)())deletionHandler cancelHandler:(void (^)())cancelHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        deletionHandler();
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancelHandler();
    }];
    
    [alertController addAction:deleteAction];
    [alertController addAction:cancelAction];
    
    return alertController;
}

@end
