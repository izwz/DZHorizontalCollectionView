//
//  ViewController.m
//  DZHorizontalCollectionView
//
//  Created by zwz on 2017/6/22.
//  Copyright © 2017年 zwz. All rights reserved.
//

#import "ViewController.h"
#import "DZHorizontalCollectionView.h"
#import "DZModel.h"

static NSString * const cellIndentifier = @"cellIndentifier";

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong) NSMutableArray *models;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UICollectionView
    _models = [NSMutableArray array];
    
    for (NSInteger i = 0 ; i < 15; i ++) {
        DZModel *model = [[DZModel alloc] init];
        model.age = i;
        model.name = [NSString stringWithFormat:@"name_%ld",(long)i];
        
        [_models addObject:model];
    }
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _models.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell       = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    
    
    
    cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? [UIColor blackColor] : [UIColor whiteColor];
    
    return cell;
}

#pragma mark - lazy laod

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 150) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
//        _collectionView.bounces = YES;
//        _collectionView.alwaysBounceHorizontal = YES;
//        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIndentifier];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0.0;
        _flowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 150);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
