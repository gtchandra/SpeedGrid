//
//  ViewController.m
//  SpeedGrid
//
//  Created by Gabriele Tazzari on 07/03/15.
//  Copyright (c) 2015 Tazzari Gabriele. All rights reserved.
//

#import "ViewController.h"
#import "Grid.h"

@interface ViewController ()
@property Grid *gridView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property NSTimeInterval timerCount;
@property BOOL timerStopped;
@property (weak, nonatomic) IBOutlet UILabel *topLeftLabel;
@property (nonatomic) int gameWon;
@property (nonatomic) BOOL gameOver;

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.gameWon=0;
    self.gridView =[[Grid alloc] initWithNum:20];
    self.topLabel.text=[NSString stringWithFormat:@"%d",self.gridView.topScore];
    [self scoreViewUpdate];
    //necessary pass the subviewcontroller
    // Do any additional setup after loading the view.
    // link already defined by the specific outlet of datasource and delegate
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(timeUpdate:)
                                   userInfo:nil
                                    repeats:YES];
    self.timerCount=600;
    self.timerStopped=NO;
    self.gameOver=NO;
    [[NSNotificationCenter defaultCenter]
     addObserver:self
        selector:@selector(nextGame:)
            name:@"GridNotificationDone"
          object:nil];
}

- (IBAction)resetView:(id)sender {
    [self.gridView reset];
    [self scoreViewUpdate];
    [self.collectionView reloadData];
    self.timerCount=600;
    self.gameOver=NO;
    if (self.timerStopped)
    {
    self.timerStopped=NO;
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(timeUpdate:)
                                   userInfo:nil
                                    repeats:YES];
    }
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


-(void)nextGame:(NSNotification*)note {
    NSLog(@"notified %@",note);
    self.gameWon++;
    self.gridView.score=self.gridView.score*2;
    [self scoreViewUpdate];
    [self.gridView shuffle];
    [self.collectionView reloadData];
    NSLog(@"NEW GAME");
    [self repaintCellsWithColor:[UIColor whiteColor] withRandom:YES];
}

-(NSString *) timerView:(int) time {
    int seconds=time/10;
    int decimal=(int)time % 10;
    return [NSString stringWithFormat:@"%d:%d", seconds,decimal];
}
-(void) scoreViewUpdate {
    self.topLeftLabel.text=[NSString stringWithFormat:@"s[%d]t[%d]",self.gridView.score,self.gridView.topScore];
    NSLog(@"score updated");
}

- (void)timeUpdate:(NSTimer *)myTimer {
    if (!self.timerStopped) {
        if (self.timerCount<=0) {
            self.timerStopped=YES;
            self.timerCount=0;
            self.gameOver=YES;
            }
        else {
            self.timerCount--;
        }
        self.topLabel.text=[NSString stringWithFormat:@"[  %@  ]", [self timerView:self.timerCount]];

    }
    else {
        [self repaintCellsWithColor:[UIColor grayColor] withRandom:NO];
        [myTimer invalidate];
        myTimer=nil;
    }
/*
    else
    {
        [myTimer invalidate];
        myTimer = nil;
    }
*/
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
    return 1;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark CollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"item in collection: %lu", (unsigned long)[self.gridView.list count]);
    return [self.gridView.list count];
}

- (void) repaintCellsWithColor:(UIColor *) color withRandom: (BOOL) random {
    
    if (random) {
        for(UICollectionViewCell *cell in self.collectionView.visibleCells)
        {
            int rnum= arc4random()%255;
            cell.backgroundColor = [UIColor colorWithHue:rnum/255.0 saturation:1.0 brightness:0.9 alpha:1.0];
        }
    }
    else
    {
        for(UICollectionViewCell *cell in self.collectionView.visibleCells)
        {
            cell.backgroundColor = color;
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *) collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell"forIndexPath:indexPath];
    [cell.layer setCornerRadius:10];
    // Configure the cell...
    NSNumber *cellValue = [self.gridView.list objectAtIndex:indexPath.row];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,cell.bounds.size.width,cell.bounds.size.height)];
    label.font = [UIFont boldSystemFontOfSize:32];
    [label setText:[cellValue stringValue]];
    label.textColor = [UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.tag = 237;
    cell.backgroundColor = [UIColor blueColor];
    [[cell.contentView viewWithTag:237] removeFromSuperview];
    [cell.contentView addSubview:label];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //UICollectionViewCell *cell = [self collectionView:collectionView cellForItemAtIndexPath: indexPath];
    if (!self.gameOver)
    {
    int tappedValue=[[self.gridView.list objectAtIndex:indexPath.row] intValue];
    if ([self.gridView tap:(int)tappedValue]) {
        [self repaintCellsWithColor:[UIColor whiteColor] withRandom:YES];
        self.gridView.score=self.gridView.score+tappedValue*(1+self.gameWon);
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        
        [UIView animateWithDuration: 0.3 animations:^{
            cell.backgroundColor=[UIColor blackColor];
        } completion:nil];
    }
    else
    {
        self.gridView.score=self.gridView.score/2;
    }
    NSLog(@"reached");
    [self scoreViewUpdate];
    }
}

- (IBAction)reset:(UIButton *)sender {
}
@end
