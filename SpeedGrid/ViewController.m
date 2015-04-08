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


@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.gridView =[[Grid alloc] initWithNum:20];
    self.topLabel.text=[NSString stringWithFormat:@"%d",self.gridView.topScore];
    self.topLeftLabel.text=[NSString stringWithFormat:@"TOP [%@]",[self scoreView:self.gridView.topScore]];
    //necessary pass the subviewcontroller
    // Do any additional setup after loading the view.
    // link already defined by the specific outlet of datasource and delegate
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(timeUpdate:)
                                   userInfo:nil
                                    repeats:YES];
    self.timerCount=0;
    self.timerStopped=NO;
    [[NSNotificationCenter defaultCenter]
     addObserver:self
        selector:@selector(timeStopped:)
            name:@"GridNotificationGameEnded"
          object:nil];
}

- (IBAction)resetView:(id)sender {
    [self.gridView reset];
    [self.collectionView reloadData];
    self.timerCount=0;
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


-(void)timeStopped:(NSNotification*)note {
    NSLog(@"notified %@",note);
    [self.gridView updateTopScore:self.timerCount];
    self.topLeftLabel.text=[NSString stringWithFormat:@"TOP [%@]",[self scoreView:self.gridView.topScore]];
    self.timerStopped=YES;
}

-(NSString *) scoreView:(int) score {
    int seconds=score/10;
    int decimal=(int)score % 10;
    return [NSString stringWithFormat:@"%d:%d", seconds,decimal];
}

- (void)timeUpdate:(NSTimer *)myTimer {
    if (!self.timerStopped) {
            self.timerCount++;
            self.topLabel.text=[NSString stringWithFormat:@"[  %@  ]", [self scoreView:self.timerCount]];
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
        NSLog(@"ramo else setta colore");
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
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(7, 7,cell.bounds.size.width-14,cell.bounds.size.height-14)];
    // ALTERNATIVE CENTER MANAGEMENT
    //UILabel *label=[[UILabel alloc] init];
    //CGPoint superCenter = CGPointMake(CGRectGetMidX([cell bounds]), CGRectGetMidY([cell bounds]));
    //[label setCenter:superCenter];
    
    label.font = [UIFont boldSystemFontOfSize:32];
    [label setText:[cellValue stringValue]];
    label.textColor = [UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.tag = 237;
    cell.backgroundColor = [UIColor grayColor];
    [[cell.contentView viewWithTag:237] removeFromSuperview];
    [label setUserInteractionEnabled:false];
    [cell.contentView addSubview:label];
    [cell setUserInteractionEnabled:true];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //UICollectionViewCell *cell = [self collectionView:collectionView cellForItemAtIndexPath: indexPath];

    int tappedValue=[[self.gridView.list objectAtIndex:indexPath.row] intValue];
    if ([self.gridView tap:(int)tappedValue]) {
        [self repaintCellsWithColor:[UIColor whiteColor] withRandom:YES];
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        
        [UIView animateWithDuration: 0.3 animations:^{
            cell.backgroundColor=[UIColor blackColor];
        } completion:nil];
    }
    else
    {
        NSLog(@"TAPPED grid: %ld num: %@",(long)indexPath.row, [(NSNumber *)[self.gridView.list objectAtIndex:indexPath.row] stringValue]);
    }
}

- (IBAction)reset:(UIButton *)sender {
}
@end
