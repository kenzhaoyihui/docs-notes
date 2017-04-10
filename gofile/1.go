package main
import (
  "fmt"
  "unsafe"
)
/*
var x int = 12
const (
  i = 1<<iota
  j = 3<<iota
  k
  l
  m = 1<<iota
  n
  c
  KB int64 = 1<<(10*(iota-6))
  MB
  GB
  TB
)
*/

/*
var x, y, z int
var s ,n = "abc", 123

var (
  a int
  b float32
)

func main() {
  //n := 0x1234
  fmt.Println(x,y,z,s,n)
  //fmt.Println("hello")
}
*/
/*
func test() (int, string) {
  return 1, "adc"
}

func test1() (int) {
  return 2
}
*/

func getSequence() func() int{
  i := 0
  return func() int{
    i += 1
    return i
  }
}

type Circle struct {
  radius float64
}

func (c Circle) getArea() float64{
  return 3.14 * c.radius * c.radius
}

func main() {

  //fmt.Println('a')

  //var c1, c2 rune = '\u6211', '们'
  //fmt.Println(c1=='我', string(c2)=="\xe4\xbb\xac")
  //_,s := test()
  //a := test1()
  //fmt.Println(s)
  //fmt.Println(i,j,k,l,m,n,KB,MB,GB,TB)
  //println(s)
  /*
  s := "abcd"
  bs := []byte(s)
  bs[1] = 'B'
  u := "电脑"
  us := []rune(u)
  us[1] = '话'
  fmt.Println(string(bs))
  fmt.Println(string(us))
  */
  /*
  s := "abc汉字"
  for i:=0;i<len(s);i++{
    fmt.Printf("%c,", s[i])
  }
  fmt.Println()
  for i, r := range s {
    fmt.Printf("%d:%c,", i,r)
  }
  fmt.Println()
*/

/*
  type data struct{
    a int
  }

  var d = data{1234}
  var p *data
  p = &d
  fmt.Printf("%v\n",p.a)
  */

/*
  x := 0x12345678
  p := unsafe.Pointer(&x)
  n := (*[4]byte)(p)

  for i:=0;i<len(n);i++{
    fmt.Printf("%X \n", n[i])
  }
  */

  d := struct {
    s string
    x int
  }{"abc", 100}

  p := uintptr(unsafe.Pointer(&d)) //*struct -> Pointer -> uintptr
  //fmt.Println(p)
  p += unsafe.Offsetof(d.x)  //uintptr +offset
  //fmt.Println(p)

  p2 := unsafe.Pointer(p)  // uintptr -> Pointer

  px := (*int)(p2)     // Pointer -> *int
  fmt.Println(*px)
  //*px = 200

  fmt.Printf("%#v\n", d)

  var y interface{
  }
  switch i := y.(type) {
  case nil:
    fmt.Println("nil")
  case int:
    fmt.Println("int")
  case float64:
    fmt.Println("float64")
  case func(int):
    fmt.Println("func(int)")
  case bool, string:
    fmt.Println("bool or string")
  default:
    fmt.Println("unknown")
  }

  var i int
  for {
    fmt.Println(i)
    i++
    if i>2{
      goto BREAK
    }
  }
  BREAK: fmt.Println("break")

  L1:
  for x:=0;x<3;x++{
    L2:
    for y:=0;y<5;y++{
      if y>2{continue L2}
      if x>1{break L1}
      print(x,":",y," ")
    }
    fmt.Println()
  }

  // closed package along function, can use the variable without delare
  // nextNumber is a function, i=0
  nextNumber := getSequence()

  fmt.Println(nextNumber())
  fmt.Println(nextNumber())
  fmt.Println(nextNumber())

  nextNumber1 := getSequence()
  fmt.Println(nextNumber1())
  fmt.Println(nextNumber1())


  // function method transp--
  var c1 Circle
  c1.radius = 10.00
  fmt.Println("Area of Circle(c1) = ", c1.getArea())
}
