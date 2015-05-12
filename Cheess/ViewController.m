//
//  ViewController.m
//  Cheess
//
//  Created by Nikolay on 12.05.15.
//  Copyright (c) 2015 gng. All rights reserved.
//

#import "ViewController.h"

#define SIZE_CELL 80.0f
#define COUNT_ROW 8.0f
#define COUNT_COL 8.0f


@interface ViewController ()

@property (nonatomic, weak) UIView * boardCheess;

@property (nonatomic, weak) UIView * someView;

@property (nonatomic, assign) CGPoint difPoint;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setView];
    
}


-(void) setView {
    
    [self createBoardCheess];
    
    //[self createFigures];
    [self addFigures_To_Board];

}

-(void) createBoardCheess {
    
    int boardWidth = SIZE_CELL * COUNT_COL;
    int boardHeight = SIZE_CELL * COUNT_ROW;
    
    UIView * board = [[UIView alloc] initWithFrame:CGRectMake(50, 50, boardWidth, boardHeight)];
    board.backgroundColor = [UIColor whiteColor];
    board.layer.borderWidth = 4;
    board.layer.borderColor = [UIColor blackColor].CGColor;
    
    int posX, posY;
    
    for (int indrow = 0; indrow < COUNT_ROW; indrow++) {
    
        posY = SIZE_CELL * indrow;
        
        for (int indcol = 0; indcol < COUNT_COL; indcol++) {
    
            posX = SIZE_CELL * indcol;
        
            UIView * cell = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, SIZE_CELL, SIZE_CELL)];
        
            if ((indrow % 2) == 0) {
                if ((indcol % 2) == 0) {
                    cell.backgroundColor = [UIColor whiteColor];
                }
                else {
                    cell.backgroundColor = [UIColor grayColor];
                }
            }
            else {
                if ((indcol % 2) == 0) {
                    cell.backgroundColor = [UIColor grayColor];
                }
                else {
                    cell.backgroundColor = [UIColor whiteColor];
                }
            }
        
            cell.layer.borderWidth = 1;
            cell.layer.borderColor = [UIColor blackColor].CGColor;
            [board addSubview:cell];
        }
    }
    
    self.boardCheess = board;
    
    [self.view addSubview:self.boardCheess];

    
}

-(void) createFigures {
    
    //pawn_black
    UIView * pawn_black = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SIZE_CELL, SIZE_CELL)];
    //board.backgroundColor = [UIColor whiteColor];
    pawn_black.layer.borderWidth = 1;
    pawn_black.layer.borderColor = [UIColor blackColor].CGColor;

    UIImageView * imageView = [[UIImageView alloc] initWithFrame:pawn_black.bounds];
    
    UIImage * image = [UIImage imageNamed:@"pawn_b.png"];
    
    imageView.image = image;
    
    [pawn_black addSubview:imageView];
    
    [self.boardCheess addSubview:pawn_black];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch * touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self.boardCheess];
    
    UIView * someAnotherView = [self.boardCheess hitTest:point withEvent:event];
    
    if (![someAnotherView isEqual:self.boardCheess]) {
        self.someView = someAnotherView;
        
        [self.view bringSubviewToFront:self.someView];
        
        UITouch * touch = [touches anyObject];
        
        CGPoint point = [touch locationInView:self.someView];
        
        //self.difPoint = CGPointMake(self.someView.frame.size.width/2, self.someView.frame.size.height/2);
        
        self.difPoint = CGPointMake(CGRectGetMidX(self.someView.bounds) - point.x,CGRectGetMidY(self.someView.bounds) - point.y);
        
        
        [UIView animateWithDuration:0.3 animations:^{
            self.someView.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
            self.someView.alpha = 0.5;
        }];
        
        NSLog(@"touchesBegan %@", NSStringFromCGPoint(point));
        
    }
    else {
        self.someView = nil;
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (self.someView) {
        
        UITouch * touch = [touches anyObject];
        
        CGPoint point = [touch locationInView:self.view];
        
        CGPoint mainPoint = CGPointMake(point.x + self.difPoint.x, point.y + self.difPoint.y);
        
        self.someView.center = mainPoint;
    }
    
    NSLog(@"touchesMoved");
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //[self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.someView.transform = CGAffineTransformIdentity;
        self.someView.alpha = 1.0;
    }];
    
    NSLog(@"touchesEnded");
    
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesCancelled");
    
}





#pragma mark - figures

- (void) addFigures_To_Board {
    
    NSMutableArray * images = [NSMutableArray array];
    
    NSMutableArray * names = [NSMutableArray array];
    
    NSFileManager * manager = [NSFileManager new];
    
    NSBundle * bundle = [NSBundle mainBundle];
    
    NSDirectoryEnumerator * enumerator = [manager enumeratorAtPath:[bundle bundlePath]];
    
    for (NSString * name in enumerator) {
        
        if ([name hasSuffix:@".png"]) {
            [names addObject:name];
        }
    }
    
    NSLog(@"names %@", names);
    
    for (NSString * imageName in names) {
        
        UIImage * image = [UIImage imageNamed:imageName];
        
        [images addObject:image];
    }
    
    for (int i = 0; i < images.count; i++) {
        
        
        UIView * figureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SIZE_CELL, SIZE_CELL)];
        figureView.layer.borderColor = [UIColor blackColor].CGColor;
        figureView.layer.borderWidth = 1;
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:figureView.bounds];
        
        imageView.image = [images objectAtIndex:i];
        
        [figureView addSubview:imageView];
        
        
        [self.boardCheess addSubview:figureView];
        
        
    }
    
    
}


@end
