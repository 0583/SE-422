package Index

import (
    "bytes"
    "encoding/json"
    "io"
    "k8s.io/api/core/v1"
    metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
    "k8s.io/client-go/kubernetes"
    "k8s.io/client-go/tools/clientcmd"
    schedulerapi "k8s.io/kubernetes/pkg/scheduler/api/v1"
    "log"
    "net/http"
)

// index nodes implementation
var visitors = 0
func Index(args schedulerapi.ExtenderArgs) *schedulerapi.ExtenderFilterResult {

    visitors++

    result := schedulerapi.ExtenderFilterResult{
        Word: "Welcome to our scheduler API!",
        VisitorCount: visitors,
    }

    return &result
}