//
//  DZHorizontalCollectionView.m
//  DZHorizontalCollectionView
//
//  Created by zwz on 2017/6/22.
//  Copyright © 2017年 zwz. All rights reserved.
//

#import "DZHorizontalCollectionView.h"
#import "DZHorizontalCollectionViewCell.h"
#import "DZHorizontalCollectionViewFlowLayout.h"

static NSString * const cellIndentifier = @"cellIndentifier";


@interface DZHorizontalCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,copy) Class cellClass;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) DZHorizontalCollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong) NSMutableArray *models;

@end

@implementation DZHorizontalCollectionView

#pragma mark - init 

- (instancetype)initWithFrame:(CGRect)frame customCell:(Class)cell {
    self = [super initWithFrame:frame];
    if (self) {
        self.cellClass = cell;
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)reloadData:(NSArray *)data {
    if (!self.models) {
        self.models = [NSMutableArray array];
    }
    [self.models removeAllObjects];
    [self.models addObjectsFromArray:data];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _models.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DZHorizontalCollectionViewCell *cell = (DZHorizontalCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    [cell setModel:self.models[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.itemWidth ?: [UIScreen mainScreen].bounds.size.width - self.margin * 2;
    CGFloat height = self.bounds.size.height;
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, self.margin, 0, self.margin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.spacing;
}


#pragma mark - lazy laod

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:self.cellClass forCellWithReuseIdentifier:cellIndentifier];
    }
    return _collectionView;
}

- (DZHorizontalCollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[DZHorizontalCollectionViewFlowLayout alloc] init];
    }
    return _flowLayout;
}



@end
