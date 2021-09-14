# This really needs to be redone, probably through the use of macros
# instead of templates, using `instantiationInfo()` for accurate func names.
# And it's not great that this file is being included instead of imported...

type OptickCategory = cstring
# type OptickCategory* {.pure.} = enum
#     None
#     AI
#     Animation
#     Audio
#     Debug
#     Camera
#     Cloth
#     GameLogic
#     Input
#     Navigation
#     Network
#     Physics
#     Rendering
#     Scene
#     Script
#     Streaming
#     UI
#     VFX
#     Visibility
#     Wait
#     WaitEmpty


when defined release:
    template optickFrame(name : cstring) {.used.} = discard
    template optickEvent {.used.} = discard
    template optickEvent(name : cstring) {.used.} = discard
    template optickTag(tag : cstring, value : int) {.used.} = discard
    template optickTag(tag : cstring, value : float) {.used.} = discard
    template optickTag(tag : cstring, value : auto) {.used.} = discard
    
else:
    {.emit:"#include \"optick/optick.h\"".}
    {.link:"optick/debug/OptickCore.lib"}

    template optickFrame(name : cstring) {.used.} =
        {.emit:["OPTICK_FRAME(\"",name,"\");"].}

    template optickEvent {.used.} =
        {.emit:"OPTICK_EVENT();".}
    
    template optickEvent(name : cstring) {.used.} =
        {.emit:["OPTICK_EVENT(\"",name,"\");"].}
    
    template optickGpuFlip() {.used.} =
        {.emit:["OPTICK_GPU_FLIP(0);"].}
    
    template optickCategory(category : OptickCategory) {.used.} =
        {.emit:["OPTICK_CATEGORY(OPTICK_FUNC, Optick::Category::",`category`,");"].}
    
    template optickCategory(name : cstring, category : OptickCategory) {.used.} =
        {.emit:["OPTICK_CATEGORY(\"",name,"\", Optick::Category::",`category`,");"].}

    template optickTag(tag : cstring, value : int) {.used.} =
        {.emit:["OPTICK_TAG(\"", `tag`, "\",(int)", `value`, ");"].}

    template optickTag(tag : cstring, value : float) {.used.} =
        {.emit:["OPTICK_TAG(\"", `tag`, "\",(float)", `value`, ");"].}

    template optickTag(tag : cstring, value : auto) {.used.} =
        {.emit:["OPTICK_TAG(\"", `tag`, "\",", `value`, ");"].}
