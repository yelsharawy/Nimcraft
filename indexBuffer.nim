import nimgl/opengl
import glUtils

type
    IndexBuffer* = object
        rendererID : GLuint
        count : GLuint

using
    ibo* : IndexBuffer
    iboV : var IndexBuffer

func count*(ibo) : uint32 {.inline.} = ibo.count

proc newIndexBuffer*(data : pointer, count : uint32) : IndexBuffer =
    result.count = count
    glCall glGenBuffers(1, addr result.rendererID)
    glCall glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, result.rendererID)
    glCall glBufferData(GL_ELEMENT_ARRAY_BUFFER, count.int * sizeof(GLuint), data, GL_STATIC_DRAW)

proc `=destroy`*(iboV) =
    glCall glDeleteBuffers(1, addr iboV.rendererID)

proc bindBuffer*(ibo) =
    glCall glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo.rendererID)

proc unbindBuffer*(ibo) =
    glCall glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0)