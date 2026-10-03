Context belongs in an overlay.

Skill for how to write system contexts.

Data in general should not live within the top level file, in general we all
need to support loading any substructure within the yaml from another yaml at a
filepath-as-jsonpath-type-thing - this is why the backing data
store graph (ATproto) with strongRefs is the approriate network representation.

filepath-as-jsonpath-type-thing means: https://github.com/dffml/dffml/blob/8a08b94f503a7c8bd8535fcbc14616958e7555d8/dffml/configloader/configloader.py#L106
