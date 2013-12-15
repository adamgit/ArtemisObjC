/**
 http://code.google.com/p/artemis-framework/source/browse/src/com/artemis/Manager.java
 
 ObjC: doesnt have abstract classes, so this is customized slightly
 
 */
#import <Foundation/Foundation.h>

#import "ArtemisEntityObserver.h"
@class ArtemisWorld;

@interface ArtemisManager : NSObject <ArtemisEntityObserver>

/** objc: has to be public */
@property(nonatomic,retain) ArtemisWorld* world;

-(void) initialize;

@end
