{.used.}
type OptickCategory* = cstring
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
    # {.link:"optick/release/OptickCore.lib"}
    template optickFrame*(name : cstring) = discard
    template optickEvent* = discard
    template optickEvent*(name : cstring) = discard
    template optickTag*(tag : cstring, value : int) = discard
    template optickTag*(tag : cstring, value : float) = discard
    template optickTag*(tag : cstring, value : auto) = discard
    
else:
    {.emit:"#include \"optick/optick.h\"".}
    {.link:"optick/debug/OptickCore.lib"}

    template optickFrame*(name : cstring) =
        {.emit:["OPTICK_FRAME(\"",name,"\");"].}

    template optickEvent* =
        {.emit:"OPTICK_EVENT();".}
    
    template optickEvent*(name : cstring) =
        {.emit:["OPTICK_EVENT(\"",name,"\");"].}
    
    template optickGpuFlip*() =
        {.emit:["OPTICK_GPU_FLIP(0);"].}
    
    template optickCategory*(category : OptickCategory) =
        {.emit:["OPTICK_CATEGORY(OPTICK_FUNC, Optick::Category::",`category`,");"].}
    
    template optickCategory*(name : cstring, category : OptickCategory) =
        {.emit:["OPTICK_CATEGORY(\"",name,"\", Optick::Category::",`category`,");"].}

    template optickTag*(tag : cstring, value : int) =
        {.emit:["OPTICK_TAG(\"", `tag`, "\",(int)", `value`, ");"].}

    template optickTag*(tag : cstring, value : float) =
        {.emit:["OPTICK_TAG(\"", `tag`, "\",(float)", `value`, ");"].}

    template optickTag*(tag : cstring, value : auto) =
        {.emit:["OPTICK_TAG(\"", `tag`, "\",", `value`, ");"].}
