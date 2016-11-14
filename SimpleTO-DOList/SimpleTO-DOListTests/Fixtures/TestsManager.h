//
//  TestsManager.h
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 21/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import <MagicalRecord/MagicalRecord.h>
#import <RestKit/RestKit.h>

@interface TestsManager : NSObject

+ (BOOL)setUp;
+ (BOOL)tearDown;

@end
