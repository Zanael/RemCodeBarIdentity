//
//  REMMergedCell.m
//  RemCodeBarIdentity
//
//  Created by Alexander Devin on 19/07/2017.
//  Copyright © 2017 NLMK. All rights reserved.
//

#import "REMMergedCell.h"

@implementation REMMergedCell

-(instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"";
        self.cells = [NSMutableArray<REMCell*> new];
    }
    return self;
}

@end
