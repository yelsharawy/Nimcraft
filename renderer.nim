{.used.}
include optick
import nimgl/[glfw, opengl]
import glm
import glUtils
import vertexArray, vertexBuffer, indexBuffer, vertexBufferLayout, shader


using
    va : VertexArray
    vb : VertexBuffer
    ib : IndexBuffer
    vbl : VertexBufferLayout
    shader : Shader

proc clear* =
    optickCategory("clear_renderer.nim","Rendering")
    glCall glClearColor(0.68f, 1f, 0.34f, 1f)
    glCall glClear(GL_COLOR_BUFFER_BIT)

proc draw*(va, ib, shader) =
    # optickEvent()
    optickCategory("draw_renderer.nim","Rendering")
    shader.bindShader
    va.bindBuffer
    ib.bindBuffer
    
    glCall glDrawElements(GL_TRIANGLES, ib.count.int32, GL_UNSIGNED_INT, nil)