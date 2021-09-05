import nimgl/opengl
import glUtils

type
    VertexBuffer* = object
        rendererID : GLuint

using
    vbo* : VertexBuffer
    vboV : var VertexBuffer

proc newVertexBuffer*(data : pointer, size : uint32) : VertexBuffer =
    glCall glGenBuffers(1, addr result.rendererID)
    glCall glBindBuffer(GL_ARRAY_BUFFER, result.rendererID)
    glCall glBufferData(GL_ARRAY_BUFFER, size.int, data, GL_STATIC_DRAW)

proc `=destroy`*(vboV) =
    glCall glDeleteBuffers(1, addr vboV.rendererID)

proc bindBuffer*(vbo) =
    glCall glBindBuffer(GL_ARRAY_BUFFER, vbo.rendererID)

proc unbindBuffer*(vbo) =
    glCall glBindBuffer(GL_ARRAY_BUFFER, 0)