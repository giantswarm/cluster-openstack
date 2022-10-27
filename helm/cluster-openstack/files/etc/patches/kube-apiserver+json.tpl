[
    {
        "op": "add",
        "path": "/spec/dnsPolicy",
        "value": "ClusterFirstWithHostNet"
    },
    {
        "op": "add",
        "path": "/spec/containers/0/command/-",
        "value": "--max-requests-inflight=$MAX_REQUESTS_INFLIGHT"
    },
    {
        "op": "add",
        "path": "/spec/containers/0/command/-",
        "value": "--max-mutating-requests-inflight=$MAX_MUTATING_REQUESTS_INFLIGHT"
    },
    {
        "op": "replace",
        "path": "/spec/containers/0/resources/requests/cpu",
        "value": "$API_SERVER_CPU_REQUEST"
    },
    {
        "op": "replace",
        "path": "/spec/containers/0/resources/requests/memory",
        "value": "$API_SERVER_MEMORY_REQUEST"
    }
]
