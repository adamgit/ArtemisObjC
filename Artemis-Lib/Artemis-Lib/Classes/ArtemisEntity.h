/**
 http://code.google.com/p/artemis-framework/source/browse/src/com/artemis/Entity.java
 */
#import <Foundation/Foundation.h>

#import "ArtemisBitSet.h"
#import "ArtemisComponent.h"
#import "ArtemisComponentType.h"
#import "ArtemisBag.h"

@class ArtemisWorld;

@interface ArtemisEntity : NSObject

/** ObjC: doesnt support protected, moved this to static */
+(ArtemisEntity*) entityInWorld:(ArtemisWorld*) world withId:(int) newID;

@property(nonatomic) int Id; // note: not "id" which is reserved in objc

@property(nonatomic,retain,readonly) ArtemisBitSet* componentBits, * systemBits;

-(ArtemisEntity*) addComponent:( ArtemisComponent*) component;
-(ArtemisEntity*) addComponent:( ArtemisComponent*) component ofType:(ArtemisComponentType*) componentType;
-(ArtemisEntity*) removeComponent:(ArtemisComponent*) component;
/** ObjC: must rename */
-(ArtemisEntity*) removeComponentOfType:(ArtemisComponentType*) component;

/** FIXME: missing: the templated version of removeComponentOfType */

@property(nonatomic) BOOL isActive, isEnabled;

/** ObjC: slight rename */
-(ArtemisComponent*) componentOfType:(ArtemisComponentType*) componentType;

/** FIXME: missing: the templated version of componentOfType: */

-(ArtemisBag*) getComponentsIntoBag:(ArtemisBag*) fillBag;

/** Bad code from Artemis main source */
-(void) addToWorld;
/** Bad code from Artemis main source */
-(void) changedInWorld;
/** Bad code from Artemis main source */
-(void) deleteFromWorld;

/** Bad code from Artemis main source */
-(void) enable;
/** Bad code from Artemis main source */
-(void) disable;

@property(nonatomic,retain) NSUUID* uuid;

@end
