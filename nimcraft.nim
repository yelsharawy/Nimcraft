import sugar
import nimgl/[glfw, opengl]
import glUtils
import renderer
include optick

var
  window : GLFWWindow
  winWidth, winHeight : int32

func errorCallback(error : int32, description : cstring) {.cdecl.} =
  debugEcho "GLFW Error:\n", description

proc framebufferSizeCallback(window : GLFWWindow, width, height : int32) {.cdecl.} =
  (winWidth, winHeight) = (width, height)
  glCall glViewport(0, 0, width, height)

proc glfwSetup =
  discard glfwSetErrorCallback(errorCallback)
  assert glfwInit()
  
  glfwWindowHint(GLFWContextVersionMajor, 4)
  glfwWindowHint(GLFWContextVersionMinor, 4)
  glfwWindowHint(GLFWOpenglForwardCompat, GLFW_TRUE) # Used for Mac
  glfwWindowHint(GLFWOpenglProfile, GLFW_OPENGL_CORE_PROFILE)
  glfwWindowHint(GLFWResizable, GLFW_TRUE)
  
  window = glfwCreateWindow(800, 800, "Nimcraft")
  assert window != nil
  window.makeContextCurrent()
  
  glfwSwapInterval(1)
  
  discard window.setFramebufferSizeCallback(framebufferSizeCallback)
  assert glInit()

proc receiveInputs =
  optickCategory("Input")
  glfwPollEvents()
  # and do nothing with them, yet

proc swapBuf =
  optickCategory("Wait")
  window.swapBuffers

proc render =
  optickEvent()
  renderer.clear()
  swapBuf()
  discard

proc mainLoop =
  while not window.windowShouldClose:
    optickFrame("MainThread")
    receiveInputs()
    render()

proc main =
  glfwSetup()
  mainLoop()

when isMainModule:
  main()
