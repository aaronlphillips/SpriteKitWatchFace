/*
 
 Erica Sadun, http://ericasadun.com
 
 */

@import SpriteKit;

@interface ShadowLabelNode : SKLabelNode
- (void) addLayer : NSDictonary;
@property (nonatomic) CGPoint offset;
@property (nonatomic) SKColor *shadowColor;
@property (nonatomic) CGFloat blurRadius;
@property (nonatomic) CGFloat shadowAlpha;

@property NSMutableArray *layers;

@property (nonatomic) int intensity;
@end
