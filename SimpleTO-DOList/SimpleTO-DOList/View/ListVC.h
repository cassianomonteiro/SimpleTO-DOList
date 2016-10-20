//
//  ListVC.h
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 19/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "List+CoreDataClass.h"

@interface ListVC : CoreDataTableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

- (IBAction)loginTapped:(UIBarButtonItem *)sender;
- (IBAction)addTapped:(UIBarButtonItem *)sender;

@end
