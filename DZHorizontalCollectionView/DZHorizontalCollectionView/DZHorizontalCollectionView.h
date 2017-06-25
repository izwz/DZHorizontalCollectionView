//
//  DZHorizontalCollectionView.h
//  DZHorizontalCollectionView
//
//  Created by zwz on 2017/6/22.
//  Copyright © 2017年 zwz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DZHorizontalCollectionViewStyle) {
    DZHorizontalCollectionViewStyleDefault,// 普通样式
    DZHorizontalCollectionViewStyleCoverflow,//coverflow
};

@protocol DZHorizontalCollectionViewDataSource,DZHorizontalCollectionViewDelegate;

@interface DZHorizontalCollectionView : UIView

@property (nonatomic,assign) DZHorizontalCollectionViewStyle style;

@property (nonatomic,assign) id <DZHorizontalCollectionViewDelegate> delegate;

@property (nonatomic,assign) id <DZHorizontalCollectionViewDataSource> dataSource;

@property (nonatomic,assign,getter = isInfinite) BOOL infinite;

@property (nonatomic,assign) NSUInteger currentIndex; /**< 当前所在的index */

@property (nonatomic,assign) CGFloat    margin;     /**< 左右边缘大小 */
@property (nonatomic,assign) CGFloat    spacing;    /**< cell间隔大小 */
@property (nonatomic,assign) CGFloat    itemWidth;  /**< cell大小 */

@property (nonatomic,assign) CGFloat minScale;  /**< 最小缩放比例 */

- (void)setCurrentIndex:(NSUInteger)currentIndex animated:(BOOL)animated;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)reloadData;

- (void)registerViewClass:(Class)viewClass refreshMthod:(SEL)method;

@end

@protocol DZHorizontalCollectionViewDataSource <NSObject>

@required
- (NSArray *)contentModelsForDzCollectionView:(DZHorizontalCollectionView *)dzCollectionView;

- (UIView *)contentViewForDzCollectionView:(DZHorizontalCollectionView *)dzCollectionView;

@end

@protocol DZHorizontalCollectionViewDelegate <NSObject>

@optional
- (void)dzCollectionView:(DZHorizontalCollectionView *)dzCollectionView didSelectItemAtIndex:(NSInteger)index;

@end
