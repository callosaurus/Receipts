//
//  ViewController.h
//  Receipts++
//
//  Created by Callum Davies on 2017-03-02.
//  Copyright © 2017 Callum Davies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewReceiptController.h"
#import <CoreData/CoreData.h>
#import "CoreDataManager.h"


@interface ViewController : UIViewController

@property (nonatomic) CoreDataManager *coreDataManager;


@end

