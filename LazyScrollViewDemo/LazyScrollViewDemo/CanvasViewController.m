//
//  ReuseViewController.m
//  LazyScrollViewDemo
//
//  Copyright (c) 2015-2018 Alibaba. All rights reserved.
//

#import "CanvasViewController.h"
#import <LazyScroll/LazyScroll.h>
#import <TMUtils/TMUtils.h>

@interface LazyScrollViewCustomView1 : UILabel <TMLazyItemViewProtocol>

@property (nonatomic, assign) NSUInteger reuseTimes;

@end

@implementation LazyScrollViewCustomView1

- (void)mui_prepareForReuse
{
    self.reuseTimes++;
}

@end

@interface LazyScrollViewModel : NSObject

@property (nonatomic, assign) NSInteger zPosition;
@property (nonatomic, assign) CGRect rect;

@end

@implementation LazyScrollViewModel

@end
//****************************************************************

@interface CanvasViewController () <TMLazyScrollViewDataSource> {
    NSMutableDictionary * _rectArray;
    NSMutableArray * _colorArray;
    TMLazyScrollView * _scrollView;
}

@end

@implementation CanvasViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"Reuse";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor: UIColor.whiteColor];
    
    // STEP 1: Create LazyScrollView
    _scrollView = [[TMLazyScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.dataSource = self;
    _scrollView.autoAddSubview = YES;
    [self.view addSubview:_scrollView];
    
    // Here is frame array for test.
    // LazyScrollView must know item view's frame before rending.
    _rectArray = [[NSMutableDictionary alloc] init];
    CGFloat maxY = 0, currentY = 50;
    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    
    LazyScrollViewModel *model1 = [[LazyScrollViewModel alloc] init];
    [model1 setZPosition: 1];
    [model1 setRect:CGRectMake(10, 10, 100, 100)];
    [_rectArray setValue:model1 forKey:@"0"];
    
    LazyScrollViewModel *model2 = [[LazyScrollViewModel alloc] init];
    [model2 setZPosition: 2];
    [model2 setRect:CGRectMake(20, 30, 100, 200)];
    [_rectArray setValue:model2 forKey:@"1"];
    
    LazyScrollViewModel *model3 = [[LazyScrollViewModel alloc] init];
    [model3 setZPosition: 5];
    [model3 setRect:CGRectMake(30, 40, 100, 400)];
    [_rectArray setValue:model3 forKey:@"2"];
    
    LazyScrollViewModel *model4 = [[LazyScrollViewModel alloc] init];
    [model4 setZPosition: 3];
    [model4 setRect:CGRectMake(0, 400, 100, 100)];
    [_rectArray setValue:model4 forKey:@"3"];
    
    // Create color array.
    // The color order is like rainbow.
    _colorArray = [NSMutableArray arrayWithCapacity:_rectArray.count];
    CGFloat hue = 0;
    for (int i = 0; i < _rectArray.count; i++) {
        [_colorArray addObject:[UIColor colorWithHue:hue saturation:1 brightness:1 alpha:1]];
        hue += 0.04;
        if (hue >= 1) {
            hue = 0;
        }
    }
    
    // STEP 3: reload LazyScrollView
    _scrollView.contentSize = CGSizeMake(viewWidth, 1000);
    [_scrollView reloadData];
    
    // A tip.
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, viewWidth - 20, 30)];
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.numberOfLines = 0;
    tipLabel.text = @"Item views's color should be from red to blue. They are reused. Magenta should not be appeared.";
    [_scrollView addSubview:tipLabel];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Visible" style:UIBarButtonItemStylePlain target:self action:@selector(loadMoreAction)];
}

- (void)loadMoreAction
{
    for (UIView *item in _scrollView.inScreenVisibleItems) {
        NSLog(@"%@", item.muiID);
    }
}

#pragma mark LazyScrollView

// STEP 2: implement datasource.
- (NSUInteger)numberOfItemsInScrollView:(TMLazyScrollView *)scrollView
{
    return _rectArray.count;
}

- (TMLazyItemModel *)scrollView:(TMLazyScrollView *)scrollView itemModelAtIndex:(NSUInteger)index
{
    
    NSString *_index = [NSString stringWithFormat:@"%zd", index];
    LazyScrollViewModel *model = [_rectArray valueForKey: _index];
    
    CGRect rect = [model rect];
    NSInteger zPosition = [model zPosition];
    TMLazyItemModel *rectModel = [[TMLazyItemModel alloc] init];
    rectModel.absRect = rect;
    rectModel.zPosition = zPosition;
    rectModel.muiID = [NSString stringWithFormat:@"%zd", index];
    return rectModel;
}

- (UIView *)scrollView:(TMLazyScrollView *)scrollView itemByMuiID:(NSString *)muiID
{
    // Find view that is reuseable first.
    LazyScrollViewCustomView1 *label = (LazyScrollViewCustomView1 *)[scrollView dequeueReusableItemWithIdentifier:@"testView"];
    NSInteger index = [muiID integerValue];
    if (!label) {
        NSLog(@"create a new label");
        label = [LazyScrollViewCustomView1 new];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.reuseIdentifier = @"testView";
        label.backgroundColor = [_colorArray tm_safeObjectAtIndex:index];
    }
    
    NSString *_index = [NSString stringWithFormat:@"%zd", index];
    LazyScrollViewModel *model = [_rectArray valueForKey: _index];
    
    label.frame = [model rect];
    if (label.reuseTimes > 0) {
        label.text = [NSString stringWithFormat:@"%zd\nlast index: %@\nreuse times: %zd", index, label.muiID, label.reuseTimes];
    } else {
        label.text = [NSString stringWithFormat:@"%zd", index];
    }
    return label;
}

@end
