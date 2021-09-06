# Code is mostly drawn off of tutorials, used for learning purposes
import sugar
import nimgl/[glfw, opengl]
import glUtils
import renderer
include optick

import vertexBuffer, indexBuffer, vertexArray, vertexBufferLayout, shader


func errorCallback(error : int32, description : cstring) {.cdecl.} =
    debugEcho "GLFW Error:\n", description


func keyfunc(window: GLFWWindow, key: int32, scancode: int32,
                         action: int32, mods: int32): void {.cdecl.} =
    if key == GLFWKey.ESCAPE and action == GLFWPress:
        window.setWindowShouldClose(true)

var drawPointer : () -> void
var swapBuf : () -> void

proc main() =
    discard glfwSetErrorCallback(errorCallback)
    assert glfwInit()
    
    glfwWindowHint(GLFWContextVersionMajor, 4)
    glfwWindowHint(GLFWContextVersionMinor, 4)
    glfwWindowHint(GLFWOpenglForwardCompat, GLFW_TRUE) # Used for Mac
    glfwWindowHint(GLFWOpenglProfile, GLFW_OPENGL_CORE_PROFILE)
    glfwWindowHint(GLFWResizable, GLFW_TRUE)
    
    var w = glfwCreateWindow(800, 800, "NimGL")
    if w == nil:
        quit(-1)
    
    discard w.setKeyCallback(keyfunc)
    w.makeContextCurrent()
    
    block:
        proc swapBufI =
            optickGpuFlip()
            optickCategory("swapBuf_nimcraft.nim","Wait")
            w.swapBuffers()
        swapBuf = swapBufI
    
    assert glInit()
    block:
        var
            vao : VertexArray
            vbo : VertexBuffer
            vbl : VertexBufferLayout
            ibo : IndexBuffer
            shader : Shader
            r, increment : float32 = 0.05f

        proc draw() =
            optickEvent("draw_nimcraft.nim")
            renderer.clear()
            
            r += increment
            if r >= 1: increment = -0.05f
            elif r <= 0: increment = 0.05f
            
            shader.setUniform4f("u_Color", r, 0.3f, 0.8f, 1.0f)
            
            # glCall glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, nil)
            renderer.draw(vao, ibo, shader)
            
            ibo.unbindBuffer
            vao.unbindBuffer
            
            swapBuf()
            # w.swapBuffers()
        
        drawPointer = draw
        
        proc framebufferSizeCallback(window : GLFWWindow, width, height : int32) {.cdecl.} =
            glCall glViewport(0, 0, width, height)
            # drawPointer()
        
        var positions = [
            -0.5f, -0.5f,
            0.5f, -0.5f,
            0.5f,  0.5f,
            -0.5f,  0.5f,
        ]
        
        var indices = [
        uint32 0, 1, 2,
               2, 3, 0
        ]
        
        vao = newVertexArray()
        vbo = newVertexBuffer(addr positions, sizeof(positions).uint32)
        
        vbl = newVertexBufferLayout()
        vbl.push[:float32](2)
        vao.addBuffer(vbo, vbl)
        
        ibo = newIndexBuffer(addr indices, 6)
        
        vbo.unbindBuffer
        ibo.unbindBuffer
        vao.unbindBuffer
        
        const vertexShader = slurp("res/shaders/shader.vert")
        const fragmentShader = slurp("res/shaders/shader.frag")
        shader = newShader(vertexShader, fragmentShader)
        shader.bindShader
        
        shader.setUniform4f("u_Color", 0.8f, 0.3f, 0.8f, 1.0f)
        
        glfwSwapInterval(1)
        
        var width, height: int32 # int
        
        w.getFramebufferSize(addr width, addr height)
        glCall glViewport(0, 0, GLint(width), GLint(height))
        
        discard w.setFramebufferSizeCallback(framebufferSizeCallback)
        
        var frame : int
        while not w.windowShouldClose:
            optickFrame("MainThread")
            glfwPollEvents()
            
            draw()
            
            inc frame
        
    w.destroyWindow()
    glfwTerminate()

main()