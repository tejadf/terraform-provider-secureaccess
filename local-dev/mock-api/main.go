package main

import (
	"fmt"
	"log"
	"net/http"
)

// Fake Secure Access API: returns the example payloads from the public OpenAPI spec.
func main() {
	http.HandleFunc("/auth/v2/token", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		fmt.Fprint(w, `{"access_token":"fake-token","expires_in":3600}`)
	})
	http.HandleFunc("/deployments/v2/regions", func(w http.ResponseWriter, r *http.Request) {
		log.Printf("%s %s auth=%q", r.Method, r.URL.Path, r.Header.Get("Authorization"))
		w.Header().Set("Content-Type", "application/json")
		fmt.Fprint(w, `{"regions":[{"name":"US East 1","region":"us-east-1","description":"US East (N. Virginia)","continent":"North America"},{"name":"US West 2","region":"us-west-2","description":"US West (N. California)","continent":"North America"}],"bgp":{"asNumber":"64512","peerIPs":["169.254.0.9","169.254.0.5"],"peerRange":"169.254.0.0/24"}}`)
	})
	log.Fatal(http.ListenAndServe("127.0.0.1:18089", nil))
}
