//
//  NewReceiptController.h
//  Receipts++
//
//  Created by Callum Davies on 2017-03-02.
//  Copyright © 2017 Callum Davies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewReceiptController : UIViewController

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSArray *tagsArray;

@end
