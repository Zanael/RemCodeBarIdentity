//
//  REMMergedCell.h
//  RemCodeBarIdentity
//
//  Created by Alexander Devin on 19/07/2017.
//  Copyright © 2017 NLMK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "REMCell.h"

@interface REMMergedCell : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray<REMCell*> *cells;

@end
