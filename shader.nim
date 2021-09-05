import strformat
import nimgl/opengl
import glUtils
import tables

type
    Shader* {.byref.} = object
        rendererID : uint32
        uniformLocationCache : Table[string, int32]

using
    shader* : Shader
    shaderV : var Shader

proc compileShader(typ : GLenum, source : string) : GLuint =
    let id = glCreateShader(typ)
    var src = source.cstring
    glCall glShaderSource(id, 1, addr src, nil)
    glCall glCompileShader(id)
    
    var output : GLint
    glCall glGetShaderiv(id, GL_COMPILE_STATUS, addr output)
    if output == 0:
        var length : GLint
        glCall glGetShaderiv(id, GL_INFO_LOG_LENGTH, addr length)
        var message : cstring = newString(length).cstring
        glCall glGetShaderInfoLog(id, length, addr length, message)
        echo "Failed to compile shader!\n", message
        glCall glDeleteShader(id)
        return 0
    id

proc newShader*(vertexShader, fragmentShader : string) : Shader =
    glCall:
        let program = glCreateProgram()
    let vs = compileShader(GL_VERTEX_SHADER, vertexShader)
    let fs = compileShader(GL_FRAGMENT_SHADER, fragmentShader)
    
    glCall glAttachShader(program, vs)
    glCall glAttachShader(program, fs)
    glCall glLinkProgram(program)
    glCall glValidateProgram(program)
    
    glCall glDeleteShader(vs)
    glCall glDeleteShader(fs)
    
    result.rendererID = program
    result.uniformLocationCache = initTable[string, int32]()

proc `=destroy`(shaderV : var Shader) =
    glCall glDeleteShader(shaderV.rendererID)

proc bindShader*(shader) =
    glCall glUseProgram(shader.rendererID)

proc unbindShader*(shader) =
    glCall glUseProgram(0)

proc getUniformLocation*(shaderV; name : string) : int32 =
    if name in shaderV.uniformLocationCache:
        return shaderV.uniformLocationCache[name]
    glCall:
        result = glGetUniformLocation(shaderV.rendererID, name.cstring)
    if result == -1:
        echo fmt"Warning: unform {name} doesn't exist!"
    shaderV.uniformLocationCache[name] = result

proc setUniform4f*(shaderV; name : string, v0, v1, v2, v3 : float32) =
    shaderV.bindShader
    template location : int32 = getUniformLocation(shaderV, name)
    glCall glUniform4f(location, v0, v1, v2, v3)