import nimgl/opengl
import glUtils

type
    VertexBufferElement = object
        typ* : GLenum
        count* : int32
        normalized* : bool
    VertexBufferLayout* = object
        stride : int32
        elements : seq[VertexBufferElement]

using
    vbe* : VertexBufferElement
    vbeV : var VertexBufferElement
    vbl* : VertexBufferLayout
    vblV : var VertexBufferLayout

func stride*(vbl) : int32 = vbl.stride
func elements*(vbl) : lent seq[VertexBufferElement] = vbl.elements

func size*(typ : GLenum) : uint32 =
    case typ:
        of EGL_FLOAT: return 4
        of GL_UNSIGNED_INT: return 4
        of GL_UNSIGNED_BYTE: return 1
        else: assert(false, "Unknown GLenum type")

func newVertexBufferLayout* : VertexBufferLayout =
    result.stride = 0

proc push*[T](vblV; count : int) =
    when T is uint32:
        vblV.elements.add(VertexBufferElement(typ:GL_UNSIGNED_INT, count:count.int32, normalized:false))
        vblV.stride += GL_UNSIGNED_INT.size.int32 * count.int32
    elif T is byte:
        vblV.elements.add(VertexBufferElement(typ:GL_UNSIGNED_BYTE, count:count.int32, normalized:false))
        vblV.stride += GL_UNSIGNED_BYTE.size.int32 * count.int32
    elif T is float32:
        vblV.elements.add(VertexBufferElement(typ:EGL_Float, count:count.int32, normalized:false))
        vblV.stride += EGL_Float.size.int32 * count.int32
    else:
        assert false, "Invalid vertex buffer layout type"


when isMainModule:
    var testLayout = newVertexBufferLayout()
    testLayout.push[:uint8](3)
    testLayout.push[:float](3)
    testLayout.push[:int](3)