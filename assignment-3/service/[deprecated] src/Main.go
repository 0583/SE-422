package main

import (
    "fmt"
    "net/http"
    "log"
    "github.com/julienschmidt/httprouter"
    "./index"
    "./rand"
)



func main() {
    router := httprouter.New()
    router.GET("/", Index)
    router.GET("/index", Index)
    router.POST("/random", Randomizer)
    log.Fatal(http.ListenAndServe(":8888", router))
}