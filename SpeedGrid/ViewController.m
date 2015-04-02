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
@property NSInteger timerCount;
@property BOOL timerStopped;

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.gridView =[[Grid alloc] initWithNum:20];
    self.topLabel.text=@"0";
    //necessary pass the subviewcontroller
    NSLog(@"CIAO set");
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
    NSLog(@"reset tapped");
    [self.gridView reset];
    [self.collectionView reloadData];
    self.timerCount=0;
    self.timerStopped=NO;
}

-(void)timeStopped:(NSNotification*)note {
    NSLog(@"notified %@",note);
    self.timerStopped=YES;
}

- (void)timeUpdate:(NSTimer *)myTimer {
    if (!self.timerStopped) {
            self.timerCount++;
            self.topLabel.text=[NSString stringWithFormat:@"%ld", (long)self.timerCount];
        [self repaintCells];
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


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"item in collection: %lu", (unsigned long)[self.gridView.list count]);
    return [self.gridView.list count];
}

- (void) repaintCells {
    for(UICollectionViewCell *cell in self.collectionView.visibleCells)
    {
        int rnum=80+ arc4random()%110;
        cell.backgroundColor = [UIColor colorWithRed:(float)rnum/255.0 green:0 blue:0 alpha:1];
    }

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell"forIndexPath:indexPath];
    [cell.layer setCornerRadius:10];
    // Configure the cell...
    
    NSNumber *cellValue = [self.gridView.list objectAtIndex:indexPath.row];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(7, 7,cell.bounds.size.width-14,cell.bounds.size.height-14)];
    label.font = [UIFont boldSystemFontOfSize:32];
    [label setText:[cellValue stringValue]];
    label.textColor = [UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.tag = 237;
    int rnum=80+ arc4random()%145;
    cell.backgroundColor = [UIColor colorWithRed:(float)rnum/255.0 green:0 blue:0 alpha:1];
    
    [[cell.contentView viewWithTag:237] removeFromSuperview];
    [label setUserInteractionEnabled:false];
    [cell.contentView addSubview:label];
    [cell setUserInteractionEnabled:true];
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //UICollectionViewCell *cell = [self collectionView:collectionView cellForItemAtIndexPath: indexPath];

    int tappedValue=[[self.gridView.list objectAtIndex:indexPath.row] intValue];
    if ([self.gridView tap:(int)tappedValue]) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        [UIView transitionWithView:cell
                          duration:.2
                           options:UIViewAnimationOptionTransitionCurlUp
                        animations:^{
                            
                            //any animatable attribute here.
                            //cell.frame = CGRectMake(3, 14, 100, 100);
                            
                        } completion:^(BOOL finished) {
                            
                            //whatever you want to do upon completion
                            
                        }];

    }
    else
    {
        NSLog(@"TAPPED grid: %ld num: %@",(long)indexPath.row, [(NSNumber *)[self.gridView.list objectAtIndex:indexPath.row] stringValue]);
    }
}

- (IBAction)reset:(UIButton *)sender {
}
@end
