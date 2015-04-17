//
//  Grid.h
//  SpeedGrid
//
//  Created by Tazzari Gabriele on 21/02/15.
//  Copyright (c) 2015 Tazzari Gabriele. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Grid : NSObject
@property (nonatomic, strong) NSMutableArray *list;
@property int currentTap;
@property int totCount;
@property int topScore;
@property (nonatomic) int score;
-(BOOL) tap:(int) number;
-(id) initWithNum:(int) number;
-(void) reset;
-(void) shuffle;
@end
