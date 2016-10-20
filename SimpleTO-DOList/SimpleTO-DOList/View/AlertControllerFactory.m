//
//  AlertControllerFactory.m
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 19/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import "AlertControllerFactory.h"

@implementation AlertControllerFactory

+ (UIAlertController *)textFieldAlertControllerWithTitle:(NSString *)title andPlaceHolder:(NSString *)placeHolder completionHandler:(void (^)(NSString *))completionHandler
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    // Keep reference to the textFieldObserver, to remove it on alert dismissal
    id __block textFieldObserver;
    
    UIAlertAction *createAction = [UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // Remove observer to void memory leaks
        [[NSNotificationCenter defaultCenter] removeObserver:textFieldObserver];
        
        // Perform completion handler on typed text
        UITextField *textField = alertController.textFields.firstObject;
        completionHandler(textField.text);
    }];
    // Start action disabled while textfield is empty
    createAction.enabled = NO;
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
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

@end
