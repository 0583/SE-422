package Randomizer
import (
    "math/rand"
)
// random nodes implementation
func Randomizer(args schedulerapi.ExtenderArgs) *schedulerapi.ExtenderFilterResult {

    result := schedulerapi.ExtenderFilterResult{
        Word: "Welcome to our scheduler API!",
        RandomNumber: rand.Intn(100),
    }

    return &result
}