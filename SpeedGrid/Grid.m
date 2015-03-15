//
//  Grid.m
//  SpeedGrid
//
//  Created by Tazzari Gabriele on 21/02/15.
//  Copyright (c) 2015 Tazzari Gabriele. All rights reserved.
//

#import "Grid.h"

@implementation Grid
-(id)init
{
    return [self initWithNum:5];
}

- (id)initWithNum:(int) number
{
    self=[super init];
    if(self)
    {
        self.totCount=number;
        self.list = [NSMutableArray array];
        for (NSInteger i=0;i < self.totCount;i++) {
            [self.list addObject:[NSNumber numberWithInteger:i+1]];
        }
        [self shuffle];
        self.currentTap=0;
    }
    return self;

}
-(void) shuffle {
    NSUInteger count = [self.list count];
    NSInteger remainingCount = count;
    for (NSInteger i=0; i<count; i++) {
        NSInteger exchangeIndex = i + arc4random_uniform(remainingCount);
        //NSLog(@"indexes i: %i exchange: %i remainingcount: %i", i, exchangeIndex,remainingCount);
        remainingCount--;
        [self.list exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}
-(BOOL) tap:(int) number {
    if ((number-1)==self.currentTap) {
        self.currentTap++;
        if (self.currentTap==self.totCount) {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"GridNotificationGameEnded"
             object:self];
        }
        return true;
    }
    else
    {
        return false;
    }
}
/*
NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [self exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
*/
@end
