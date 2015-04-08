//
//  Grid.m
//  SpeedGrid
//
//  Created by Tazzari Gabriele on 21/02/15.
//  Copyright (c) 2015 Tazzari Gabriele. All rights reserved.
//

#import "Grid.h"

@implementation Grid

- (id)initWithNum:(int) number
{
    self=[super init];
    if(self)
    {
        self.totCount=number;
        //self.list = [NSMutableArray array];
        for (NSInteger i=0;i < self.totCount;i++) {
            [self.list addObject:[NSNumber numberWithInteger:i+1]];
        }
        [self shuffle];
        self.currentTap=0;
        NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
        if (![user objectForKey:@"topScore"])
        {
            [user setObject:[NSNumber numberWithInt:0]  forKey:@"topScore"];
        }
        self.topScore=[[user objectForKey:@"topScore"] intValue];
    }
    return self;
}
-(void) updateTopScore:(int) currentScore
{
    if (currentScore<self.topScore)
    {
        NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
        self.topScore=currentScore;        
        [user setObject:[NSNumber numberWithInt:self.topScore]  forKey:@"topScore"];
        [user synchronize];
        NSLog(@"cur=%d top=%d",currentScore,self.topScore);
    }
}


-(void) reset {
    [self shuffle];
    self.currentTap=0;
}
-(NSMutableArray *) list {
    if (!_list) {
        _list=[[NSMutableArray alloc] init];
    }
    return _list;
}

-(void) shuffle {
    NSUInteger count = [self.list count];
    NSUInteger remainingCount = count;
    for (NSUInteger i=0; i<count; i++) {
        NSUInteger exchangeIndex = i + arc4random_uniform(remainingCount);
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
- (NSDictionary *)readGameInfo;

{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"game-info.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"game-info"ofType:@"plist"];
    }
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    if (dict == nil) {
        NSLog(@"Could not read plist at path %@", plistPath);
        return nil;
    }
   NSLog(@"Read game stats from plist: %@", dict);
    return dict;
} 
- (BOOL)writeGameInfo:(NSDictionary *) dictionary;

{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"game-info.plist"];
    BOOL success = [dictionary writeToFile:plistPath atomically:YES];
    if(success) {
        NSLog(@"Saved game stats to plist: %@", dictionary);
        return YES;
    } else {
        NSLog(@"Could not save to plist at path %@", plistPath);
        return NO;
    }
}



@end
