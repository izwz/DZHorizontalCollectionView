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

@property (nonatomic,strong) NSMutableArray *infiniteModels;

@property (nonatomic,strong) UIPageControl *pageControl;

@end

@implementation DZHorizontalCollectionView

#pragma mark - init 

- (instancetype)initWithFrame:(CGRect)frame customCell:(Class)cell {
    self = [super initWithFrame:frame];
    if (self) {
        self.cellClass = cell;
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)reloadData:(NSArray *)data {
    if (!self.models) {
        self.models = [NSMutableArray array];
    }
    [self.models removeAllObjects];
    [self.models addObjectsFromArray:data];
    
    if (self.isInfinite) {
        if (!self.infiniteModels) {
            self.infiniteModels = [NSMutableArray array];
        }
        [self.infiniteModels removeAllObjects];
        [self.infiniteModels addObjectsFromArray:data];
        [self.infiniteModels addObjectsFromArray:data];
        [self.infiniteModels addObjectsFromArray:data];
    }
    
    [self.collectionView reloadData];
    [self.pageControl setNumberOfPages:data.count];
    
    if (self.isInfinite) {
        NSIndexPath *defaultIndexPath = [NSIndexPath indexPathForRow:data.count inSection:0];
        [self transerIndexPath:defaultIndexPath animated:NO];
    }
}

- (void)setCurrentIndex:(NSUInteger)currentIndex {
    _currentIndex = currentIndex;
    self.pageControl.currentPage = currentIndex;
}

- (void)transerIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    [self setPageControlIndexWithIndexPath:indexPath];
    //ABCD
    //ABCD ABCD ABCD
    if (self.isInfinite) {
        // 0 ~ self.models.count - 1
        // self.models.count ~ self.models.count * 2 - 1
        // self.models.count * 2 ~ self.models.count * 3 - 1
        NSIndexPath *targetPath;
        if (indexPath.row >= 0 && indexPath.row <= self.models.count - 1) {
            targetPath = [NSIndexPath indexPathForRow:indexPath.row + self.models.count inSection:0];
        }else if (indexPath.row >= self.models.count * 2 && indexPath.row <= self.models.count * 3 - 1){
            targetPath = [NSIndexPath indexPathForRow:indexPath.row - self.models.count inSection:0];
        }else{
            targetPath = indexPath;
        }
        [self.collectionView scrollToItemAtIndexPath:targetPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    }
}

- (void)setPageControlIndexWithIndexPath:(NSIndexPath *)indexPath {
    id currentModel = self.isInfinite ? self.infiniteModels[indexPath.row] : self.models[indexPath.row];
    NSInteger realIndex = [self.models indexOfObject:currentModel];
    self.currentIndex = realIndex;
}

- (void)scrollViewDidStop:(UIScrollView *)scrollView {
    NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
    
    NSIndexPath *currentIndexPath;
    CGRect visibleRect = CGRectZero;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    for (NSIndexPath *indexPath in indexPaths) {
        UICollectionViewCell *cell  = [self.collectionView cellForItemAtIndexPath:indexPath];
        if (CGRectContainsRect(visibleRect, cell.frame)) {
            currentIndexPath = indexPath;
            break;
        }
    }
    if (currentIndexPath.row < self.models.count || currentIndexPath.row > self.models.count * 2 - 1) {
        [self transerIndexPath:currentIndexPath animated:NO];
    }
    [self setPageControlIndexWithIndexPath:currentIndexPath];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.isInfinite ? self.infiniteModels.count : self.models.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DZHorizontalCollectionViewCell *cell = (DZHorizontalCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    id model = self.isInfinite ? self.infiniteModels[indexPath.row] : self.models[indexPath.row];
    [cell setModel:model];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidStop:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidStop:scrollView];
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


- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - 50, self.bounds.size.height - 30, 100, 30)];
    }
    return _pageControl;
}


@end
