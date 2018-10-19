/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "ShadowLabelNode.h"
#if TARGET_OS_OSX
@import CoreImage.CIFilter;
#endif

NSString *const ShadowEffectNodeKey = @"ShadowEffectNodeKey";

@implementation ShadowLabelNode
{
    BOOL hasObservers;
}

#pragma mark - Updates

- (void) updateShadow
{
    [self updateShadowLayerWithKey:ShadowEffectNodeKey layer:nil];
    
    // if we have anything in our extraEffectLayers array
    // loop through them and update them as well
    if([_layers count] != 0){
        for (int i = 0; i < _layers.count; i++) {
            NSString *key = [NSString stringWithFormat:@"%@-%d", ShadowEffectNodeKey, i];
            [self updateShadowLayerWithKey:key layer:_layers[i]];
        }
    }
    
}

- (void) updateShadowLayerWithKey:(NSString *)layerKey layer:(NSDictionary*)layer
{
    SKEffectNode *effectNode = (SKEffectNode *)[self childNodeWithName:layerKey];
    if (!effectNode)
    {
        effectNode = [SKEffectNode node];
        effectNode.name = layerKey;
        effectNode.shouldEnableEffects = YES;
        effectNode.zPosition = self.zPosition - 1;
    }else{
        [effectNode removeFromParent];
    }
//#if TARGET_OS_OSX
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    CGFloat radius = _blurRadius;
//    if(layer[@"blur"]){
//        radius = (CGFloat)[layer[@"blur"] doubleValue];
//    }
//    [filter setDefaults];
//    [filter setValue:@(radius) forKey:@"inputRadius"];
//    effectNode.filter = filter;
//#else
//#endif
    [effectNode removeAllChildren];
    
    SKLabelNode *labelNode = [SKLabelNode labelNodeWithFontNamed:self.fontName];
    labelNode.text = self.text;
    labelNode.fontSize = self.fontSize;
    labelNode.verticalAlignmentMode = self.verticalAlignmentMode;
    labelNode.horizontalAlignmentMode = self.horizontalAlignmentMode;
    
    SKColor *shadowColor = layer == nil ? self.shadowColor : (SKColor*)layer[@"color"];
    CGFloat alpha = layer == nil ? self.shadowAlpha : (layer[@"alpha"] || self.shadowAlpha);
    SKColor *shadowColorWithAlpha = [shadowColor colorWithAlphaComponent:alpha];
    labelNode.fontColor = shadowColorWithAlpha;
    labelNode.position = _offset;
    [effectNode addChild:labelNode];
    
    [self insertChild:effectNode atIndex:0];
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    [self updateShadow];
}

#pragma mark - Properties

- (void) setOffset:(CGPoint)offset
{
    _offset = offset;
    [self updateShadow];
}

- (void) setShadowColor:(SKColor *)shadowColor
{
    _shadowColor = shadowColor;
    [self updateShadow];
}

- (void) setBlurRadius:(CGFloat)blurRadius
{
    _blurRadius = blurRadius;
    [self updateShadow];
}

- (void) setShadowAlpha:(CGFloat)shadowAlpha
{
    _shadowAlpha = shadowAlpha;
    [self updateShadow];
}

#pragma mark - Initialization

- (instancetype) initWithFontNamed:(NSString *)fontName
{
    if (!(self = [super initWithFontNamed:fontName])) return self;
    
    // Set defaults
    self.fontColor = [SKColor blackColor];
    _offset = CGPointMake(1, -1);
    _blurRadius = 3;
    _shadowAlpha = 0.8;
    _shadowColor = [[SKColor darkGrayColor] colorWithAlphaComponent:_shadowAlpha];
    
    // Set observers
    for (NSString *keyPath in @[@"text", @"fontName", @"fontSize", @"verticalAlignmentMode", @"horizontalAlignmentMode", @"fontColor"])
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    hasObservers = YES;
    
    // Initialize shadow
    [self updateShadow];
    
    return self;
}

- (void) addLayer:(NSObject*)newLayer
{
    if (!_layers) _layers = [[NSMutableArray alloc] init];
    // TODO: merge with defaults
    // TODO: support updating layer properties after the fact
    [_layers addObject:newLayer];
    [self updateShadow];
}

- (void) dealloc
{
    if (hasObservers)
    {
        for (NSString *keyPath in @[@"text", @"fontName", @"fontSize", @"verticalAlignmentMode", @"horizontalAlignmentMode", @"fontColor"])
            [self removeObserver:self forKeyPath:keyPath];
    }
}
@end
