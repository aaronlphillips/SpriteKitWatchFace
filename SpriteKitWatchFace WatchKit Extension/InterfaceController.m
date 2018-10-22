//
//  InterfaceController.m
//  SpriteKitWatchFace WatchKit Extension
//
//  Created by Steven Troughton-Smith on 09/10/2018.
//  Copyright © 2018 Steven Troughton-Smith. All rights reserved.
//

#import "InterfaceController.h"
#import "FaceScene.h"

@import ObjectiveC.runtime;
@import SpriteKit;

@interface NSObject (fs_override)
+(id)sharedApplication;
-(id)keyWindow;
-(id)rootViewController;
-(NSArray *)viewControllers;
-(id)view;
-(NSArray *)subviews;
-(id)timeLabel;
-(id)layer;
@end

@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:@{@"Theme":@(ThemeMarques)}];

	FaceScene *scene = [FaceScene nodeWithFileNamed:@"FaceScene"];
	
	CGSize currentDeviceSize = [WKInterfaceDevice currentDevice].screenBounds.size;
	
	/* Using the 44mm Apple Watch as the base size, scale down to fit */
    scene.camera.xScale = 184.0/currentDeviceSize.width;
    scene.camera.yScale = 224.0/currentDeviceSize.height; // 184.0/currentDeviceSize.width;

    scene.size = CGSizeMake(184, 224); // default to 44mm // scene is 154, 174 if i don't set it
   
    //scene.scaleMode = SKSceneScaleModeAspectFit; // black bar on 3 faces
    //scene.scaleMode = SKSceneScaleModeAspectFill; // zoomed in, still has black bar on bottom
    //scene.scaleMode = SKSceneScaleModeResizeFill; // black bar on bottom
    //scene.scaleMode = SKSceneScaleModeFill; // default; stretched, with black bar on bottom

    scene.camera.position = CGPointMake(0, 0);
    scene.anchorPoint = CGPointMake(.5, .5);

    NSLog(@"device size %f %f" , currentDeviceSize.width, currentDeviceSize.height);
    NSLog(@"cam scale %f %f" , scene.camera.xScale, scene.camera.yScale);
    NSLog(@"scene scale %f %f", scene.xScale, scene.yScale);
    NSLog(@"cam pos %f %f" , scene.camera.position.x, scene.camera.position.y);
    NSLog(@"scene size %f %f", scene.size.width, scene.size.height);
    
    //if (@available(iOS 10.0, *)) {
        self.scene.preferredFramesPerSecond = 30; // reduce framerate to hopefully reduce battery consumption
    //} else {
    //    self.scene.frameInterval = 4; //Deprecated
    //}

    scene.outerViewReference = self.scene;
	[self.scene presentScene:scene];
}

- (void)didAppear
{
	/* Hack to make the digital time overlay disappear */
	
	NSArray *views = [[[[[[[NSClassFromString(@"UIApplication") sharedApplication] keyWindow] rootViewController] viewControllers] firstObject] view] subviews];
	
	for (NSObject *view in views)
	{
		if ([view isKindOfClass:NSClassFromString(@"SPFullScreenView")])
			[[[view timeLabel] layer] setOpacity:0];
	}
	
	self.crownSequencer.delegate = self;
	[self.crownSequencer focus];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

#pragma mark -

CGFloat totalRotation = 0;

- (void)crownDidRotate:(nullable WKCrownSequencer *)crownSequencer rotationalDelta:(double)rotationalDelta
{
	int direction = 1;
	totalRotation += fabs(rotationalDelta);
	
	if (rotationalDelta < 0)
		direction = -1;
	
	if (totalRotation > (M_PI_4/2))
	{
		FaceScene *scene = (FaceScene *)self.scene.scene;
		
        if(scene.theme == 0 && direction == -1){
            scene.theme = ThemeMAX - 1;
        }else{
            if ((scene.theme+direction > 0) && (scene.theme+direction < ThemeMAX))
                scene.theme += direction;
            else
                scene.theme = 0;
        }
		
		[scene refreshTheme];
		
		totalRotation = 0;
	}
}

@end



