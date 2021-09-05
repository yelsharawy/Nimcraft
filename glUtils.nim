import nimgl/opengl

when defined(debug):
    import strutils
    proc glClearError() =
        while glGetError() != GL_NO_ERROR: discard
    
    proc glLogCall() : bool =
        while (let error = glGetError(); error != GL_NO_ERROR):
            echo "[OpenGL Error] (",error.uint32.toHex,")"
            return false
        true
    
    template glCall*(x : untyped) : untyped =
        glClearError()
        x
        assert glLogCall()
    
    template debugAssert*(cond : untyped, msg = "") = assert(cond, msg)
else:
    template debugAssert*(cond : untyped, msg = "") = discard cond
    template glCall*(x : untyped) : untyped = x