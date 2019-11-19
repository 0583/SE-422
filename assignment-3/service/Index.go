package Index

// index nodes implementation
visitors := 0
func filter(args schedulerapi.ExtenderArgs) *schedulerapi.ExtenderFilterResult {

    visitors++

    result := schedulerapi.ExtenderFilterResult{
        Word: "Welcome to our scheduler API!",
        VisitorCount: visitors,
    }

    return &result
}