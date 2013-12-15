/**
 
 */
#import "ArtemisComponent.h"

@interface Velocity : ArtemisComponent

+(Velocity*) velocityWithDeltaX:(float) x deltaY:(float) y;

@property(nonatomic) float dx, dy;

@end
