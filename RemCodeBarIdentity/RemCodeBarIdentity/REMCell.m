//
//  REMCell.m
//  RemCodeBarIdentity
//
//  Created by Alexander Devin on 19/07/2017.
//  Copyright © 2017 NLMK. All rights reserved.
//

#import "REMCell.h"

@implementation REMCell

-(instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"";
        self.content = @"";
    }
    return self;
}

@end
