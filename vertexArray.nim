import nimgl/opengl
import glUtils
import vertexBuffer, vertexBufferLayout, vertexBufferLayout

type
    VertexArray* = object
        rendererID : GLuint

using
    vbo : VertexBuffer
    vbl : VertexBufferLayout
    vao* : VertexArray
    vaoV : var VertexArray

proc newVertexArray*() : VertexArray =
    glCall glGenVertexArrays(1, addr result.rendererID)
    glCall glBindVertexArray(result.rendererID)

proc `=destroy`*(vaoV) =
    glCall glDeleteVertexArrays(1, addr vaoV.rendererID)

proc bindBuffer*(vao) =
    glCall glBindVertexArray(vao.rendererID)

proc unbindBuffer*(vao) =
    glCall glBindVertexArray(0)

proc addBuffer*(vao, vbo, vbl) =
    vao.bindBuffer
    vbo.bindBuffer
    var elements = vbl.elements
    var offset : uint64
    for i,element in elements:
        let ui = i.uint32
        glCall glEnableVertexAttribArray(ui)
        glCall glVertexAttribPointer(ui, element.count, element.typ,
            element.normalized, vbl.stride, cast[pointer](offset))
        offset += element.count.uint32 * element.typ.size