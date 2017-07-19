//
//  DetailsTableViewController.h
//  RemCodeBarIdentity
//
//  Created by Alexander Devin on 19/07/2017.
//  Copyright © 2017 NLMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"
#import "REMMergedCell.h"
#import "REMCell.h"

@interface DetailsTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray<REMMergedCell*> *mergedCells;

@end
