//
//  ItemVC.h
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 19/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface ItemVC : CoreDataTableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

- (IBAction)addTapped:(UIBarButtonItem *)sender;

@end
