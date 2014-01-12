ArtemisObjC
===========

Objective-C port of Artemis Entity System - c.f. http://gamadu.com/artemis/

# Status

January 2014: Artemis is great, but getting it working well in C is painful. I'm making a new open-source ES that tries to re-make Artemis as a truly cross-platform ES, and expand on some of its good ideas. More info here:

https://github.com/adamgit/ArtemisObjC/issues/4

### Version:
 - Artemis doesn't use GitHub :(, so we cannot directly track with graphs etc.
 - Currently, this port is based off version: http://code.google.com/p/artemis-framework/source/detail?r=2fa7aea9bd6295563cf6f2120b6be2b99ccd9cd6
 - (visit http://code.google.com/p/artemis-framework/source/list for the latest version numbers of original Artemis, and see how old/new that is)

# Instructions

More info, with longer explanations, here: http://t-machine.org/index.php/2013/12/29/artemis-entity-system-in-objectivec/

## ObjectiveC shortcuts

1. Generics: -- no solution yet (ObjC doesn't support them!), but look at the ObjectiveCGenerics.h file for an idea that might be usable with ArtemisBag, ArtemisComponentMapper, etc.

2. Subscripting: -- Instead of "ArtemisComponent* c = [(ArtemisComponentMapper*) get:[world getEntity:entityID]]" ... use "ArtemisComponent* c = [(ArtemisComponentMapper*)[entityID]]"

## Testing and Using

I've added Xcode Unit tests to the project that check the code works.

They also provide an excellent example for how to use Artemis-ObjC. They show clearly how the API's are mapped to the Java originals (some names have to change, for obvious reasons - different programming languages).

Run the tests, see what they do. I've only written the simplest few I needed to prove the library was working - YMMV. 

## Naming schemes

I've used <strong>identical names to the Java Artemis</strong>, apart from three exceptions:

1. Some names in Artemis are ILLEGAL in ObjectiveC (e.g. "id" is a keyword)
1. Some methods in Artemies are IMPOSSIBLE in ObjectiveC (e.g. ObjC is a crappy old language - it doesn't allow any two methods to have the same name and same number of arguments)
1. Some methods in ObjectiveC are REQUIRED/EXPECTED but are NOT NECESSARY in original Artemis
1. ...finally: some methods are IMHO necessary to use Artemis but missing from the main Artemis; these I've added as Class Extensions and placed in a separate folder so that they are easy to ignore

# Support

I will review and accept pull requests, so long as they stick to the above rules, and reference the official Artemis hash they refer to.

You can try logging Issues here, but I probably don't have time to respond. Other readers may be able to help you, if you're lucky.

Otherwise: use the main Artemis website, that's your best chance of help.

If all else fails, you can tweet me at @t_machine_org
